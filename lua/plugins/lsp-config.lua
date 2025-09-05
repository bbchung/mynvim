return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set({ 'n', 'v' }, '<leader>x', function()
                vim.lsp.buf.code_action({
                    context = {
                        only = {
                            "quickfix",
                            "source.fixAll",
                        },
                    },
                    apply = true,
                })
            end, { silent = true, desc = "LSP Quick Fix" })
            vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
            vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { silent = true })
            vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })
            vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>k", function()
                vim.lsp.buf.format({ async = true })
            end, { noremap = true, silent = true })
            -- Format selected range
            vim.keymap.set("v", "<leader>k", function()
                vim.lsp.buf.format({
                    async = true,
                    range = {
                        start = vim.fn.getpos("'<")[2] - 1, -- line numbers are 0-indexed
                        ["end"] = vim.fn.getpos("'>")[2]
                    }
                })
            end, { noremap = true, silent = true })

            vim.lsp.config('clangd', {
                cmd = { "clangd", "--background-index", "--query-driver=/usr/bin/clang++", "--pch-storage=memory", "--clang-tidy" },
                vim.api.nvim_create_user_command("A", "LspClangdSwitchSourceHeader", {})
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
                }
            })

            if vim.o.diff then
                return
            end

            vim.lsp.enable("clangd")
            vim.lsp.enable("pyright")
            vim.lsp.enable("ruff")
            vim.lsp.enable("r_language_server")
            vim.lsp.enable("lua_ls")
        end
    }
}
