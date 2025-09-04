return {
    {
        "neovim/nvim-lspconfig",
        config = function()
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
            })
            vim.lsp.enable("clangd")
            vim.lsp.enable("r_language_server")
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
            vim.lsp.enable("lua_ls")
        end
    }
}
