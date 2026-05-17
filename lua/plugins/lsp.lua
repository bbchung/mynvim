return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local function lsp_diagnostic(diagnostic)
                return diagnostic.user_data and diagnostic.user_data.lsp or diagnostic
            end

            local function warn_or_error(diagnostic)
                return diagnostic.severity == vim.diagnostic.severity.ERROR or diagnostic.severity == vim.diagnostic.severity.WARN
            end

            local function buffer_range(bufnr)
                local line_count = vim.api.nvim_buf_line_count(bufnr)
                local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count - 1, line_count, false)[1] or ""

                return {
                    start = { line = 0, character = 0 },
                    ["end"] = { line = line_count - 1, character = #last_line },
                }
            end

            local function action_start_line(action, uri)
                local edit = action.edit
                if not edit then
                    return -1
                end

                local changes = edit.changes and edit.changes[uri]
                if changes and changes[1] and changes[1].range then
                    return changes[1].range.start.line
                end

                for _, change in ipairs(edit.documentChanges or {}) do
                    local text_edits = change.edits
                    if change.textDocument and change.textDocument.uri == uri and text_edits and text_edits[1] and text_edits[1].range then
                        return text_edits[1].range.start.line
                    end
                end

                return -1
            end

            local function apply_code_action(client, action)
                local applied = false

                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding or "utf-16")
                    applied = true
                end

                if action.command then
                    if type(action.command) == "table" then
                        vim.lsp.buf.execute_command(action.command)
                    else
                        vim.lsp.buf.execute_command(action)
                    end
                    applied = true
                end

                return applied
            end

            local function request_code_actions(bufnr, diagnostics, only, callback)
                local params = {
                    textDocument = vim.lsp.util.make_text_document_params(bufnr),
                    range = buffer_range(bufnr),
                    context = {
                        diagnostics = diagnostics,
                        only = only,
                    },
                }

                vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, callback)
            end

            local function collect_actions(results)
                local actions = {}

                for _, response in pairs(results) do
                    local client = vim.lsp.get_client_by_id(response.context.client_id)
                    if client then
                        for _, action in ipairs(response.result or {}) do
                            if action.edit or action.command then
                                table.insert(actions, { client = client, action = action })
                            end
                        end
                    end
                end

                return actions
            end

            local function preferred_or_all(actions)
                local preferred = vim.tbl_filter(function(item)
                    return item.action.isPreferred
                end, actions)

                if #preferred > 0 then
                    return preferred
                end

                return actions
            end

            local function FixAll()
                local bufnr = vim.api.nvim_get_current_buf()
                local diagnostics = {}

                for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
                    if warn_or_error(diagnostic) then
                        table.insert(diagnostics, lsp_diagnostic(diagnostic))
                    end
                end

                if #diagnostics == 0 then
                    vim.notify("No error/warning diagnostics in current buffer", vim.log.levels.INFO)
                    return
                end

                request_code_actions(bufnr, diagnostics, { "source.fixAll" }, function(fix_all_results)
                    local actions = collect_actions(fix_all_results)

                    if #actions == 0 then
                        request_code_actions(bufnr, diagnostics, { "quickfix" }, function(quickfix_results)
                            local uri = vim.uri_from_bufnr(bufnr)
                            actions = preferred_or_all(collect_actions(quickfix_results))

                            table.sort(actions, function(lhs, rhs)
                                return action_start_line(lhs.action, uri) > action_start_line(rhs.action, uri)
                            end)

                            local applied = 0
                            for _, item in ipairs(actions) do
                                if apply_code_action(item.client, item.action) then
                                    applied = applied + 1
                                end
                            end

                            vim.notify(string.format("Applied %d LSP quick fixes", applied), vim.log.levels.INFO)
                        end)
                        return
                    end

                    local applied = 0
                    for _, item in ipairs(actions) do
                        if apply_code_action(item.client, item.action) then
                            applied = applied + 1
                        end
                    end

                    vim.notify(string.format("Applied %d LSP fix-all actions", applied), vim.log.levels.INFO)
                end)
            end

            vim.keymap.set({ 'n', 'v' }, '<leader>x', function()
                local line = vim.api.nvim_win_get_cursor(0)[1] - 1
                local diagnostics = vim.tbl_map(function(diagnostic)
                    return lsp_diagnostic(diagnostic)
                end, vim.diagnostic.get(0, { lnum = line }))

                vim.lsp.buf.code_action({
                    context = {
                        diagnostics = diagnostics,
                        only = {
                            "quickfix",
                        },
                    },
                    apply = true,
                })
            end, { silent = true, desc = "LSP Quick Fix" })
            vim.keymap.set('n', '<leader>X', FixAll, { silent = true, desc = "LSP Fix All" })
            vim.api.nvim_create_user_command("LspFixAll", FixAll, { desc = "Apply all available LSP fixes in the current buffer" })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: Go to Definition', silent = true })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: Find References', silent = true })
            vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'LSP: Rename Symbol', silent = true })
            vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'LSP: Code Action', silent = true })
            vim.keymap.set("n", "<Leader>k", function()
                vim.lsp.buf.format({ async = true })
            end, { noremap = true, silent = true })
            vim.keymap.set("x", "<Leader>k", function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
                local start_pos             = vim.api.nvim_buf_get_mark(0, "<")
                local end_pos               = vim.api.nvim_buf_get_mark(0, ">")
                local start_line, start_col = start_pos[1] - 1, start_pos[2]
                local end_line, end_col     = end_pos[1] - 1, end_pos[2]

                vim.lsp.buf.format({
                    range = {
                        ["start"] = { start_line, start_col },
                        ["end"]   = { end_line, end_col + 1 },
                    },
                })
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)
            end, { noremap = true, silent = true })

            vim.lsp.config('clangd', {
                cmd = { "clangd", "--background-index", "--query-driver=/usr/bin/clang++", "--pch-storage=memory", "--clang-tidy", "--limit-results=0", "--limit-references=0", "--rename-file-limit=0" },
            })
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",                  -- Neovim uses LuaJIT
                            path = vim.split(package.path, ";"), -- Lua modules path
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true), -- Neovim runtime API
                        },
                        telemetry = {
                            enable = false, -- disable telemetry
                        },
                    }
                },
            })

            vim.lsp.config("r_language_server", {
                root_dir = vim.fs.root(0, {".lintr", ".git", "DESCRIPTION", "*.Rproj"}),
                settings = {
                    r = {
                        lsp = {
                            diagnostics = false,
                            lintr_options = "list(indentation_linter = NULL, line_length_linter = NULL)",
                        },
                    },
                },
            })

            if vim.o.diff then
                return
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end

                    if client.server_capabilities.documentHighlightProvider then
                        local group = vim.api.nvim_create_augroup("HighlightCursorGroup", { clear = false })
                        vim.api.nvim_clear_autocmds({ group = group, buffer = args.buf })

                        local timer = nil
                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI" }, {
                            group = group,
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.clear_references()
                                if timer then vim.fn.timer_stop(timer) end
                                timer = vim.fn.timer_start(200, function()
                                    vim.lsp.buf.document_highlight()
                                end)
                            end,
                        })
                    end

                    if client.name == "clangd" then
                        vim.api.nvim_buf_create_user_command(args.buf, "A", "LspClangdSwitchSourceHeader", {})
                    end
                end,
            })



            vim.lsp.enable("clangd")
            vim.lsp.enable("pyright")
            vim.lsp.enable("ruff")
            vim.lsp.enable("r_language_server")
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("bashls")
            vim.lsp.enable("cmake")
            vim.lsp.enable("yamlls")
            vim.lsp.enable("jsonls")
        end
    },
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig", "mason-org/mason.nvim" },
    },
}
