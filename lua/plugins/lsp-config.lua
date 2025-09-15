return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set({ 'n', 'v' }, '<leader>x', function()
                vim.lsp.buf.code_action({
                    context = {
                        diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
                        only = {
                            "quickfix",
                        },
                    },
                    apply = true,
                })
            end, { silent = true, desc = "LSP Quick Fix" })
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
                cmd = { "clangd", "--background-index", "--query-driver=/usr/bin/clang++", "--pch-storage=memory", "--clang-tidy" },
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

            if vim.o.diff then
                return
            end

            local HIGHLIGHT_DELAY = 200
            local highlight_timer = nil
            local custom_cursorhold_group = vim.api.nvim_create_augroup('CustomCursorHold', { clear = true })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'TextChanged', 'TextChangedI' }, {
                group = custom_cursorhold_group,
                pattern = '*',
                callback = function()
                    vim.lsp.buf.clear_references()

                    if highlight_timer then
                        vim.fn.timer_stop(highlight_timer)
                    end

                    highlight_timer = vim.fn.timer_start(HIGHLIGHT_DELAY, function()
                        vim.lsp.buf.document_highlight()
                    end)
                end,
            })
            vim.api.nvim_create_user_command("A", "LspClangdSwitchSourceHeader", {})

            vim.lsp.enable("clangd")
            vim.lsp.enable("pyright")
            vim.lsp.enable("ruff")
            vim.lsp.enable("r_language_server")
            vim.lsp.enable("lua_ls")
        end
    }
}
