return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local buf_map = function(mode, lhs, rhs, opts)
                opts = opts or { silent = true }
                vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
            end
            buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
            buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
            buf_map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")
            buf_map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
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


            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- capabilities for nvim-cmp
            local capabilities = cmp_nvim_lsp.default_capabilities()

            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = { "clangd", "--background-index", "--query-driver=/usr/bin/clang++", "--pch-storage=memory", "--clang-tidy" },
                filetypes = { "c", "cpp" },
                root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
                on_attach = function(client, bufnr)
                    -- define a buffer-local command :A
                    vim.api.nvim_buf_create_user_command(bufnr, "A", function()
                        local params = { uri = vim.uri_from_bufnr(0) }
                        vim.lsp.buf_request(0, "textDocument/switchSourceHeader", params, function(err, result)
                            if err then
                                vim.notify("clangd switchSourceHeader error: " .. err.message, vim.log.levels.ERROR)
                                return
                            end
                            if not result then
                                vim.notify("No corresponding header/source file found", vim.log.levels.WARN)
                                return
                            end
                            vim.cmd("edit " .. vim.uri_to_fname(result))
                        end)
                    end, { desc = "Switch between source/header (clangd)" })
                end,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                filetypes = { "python" },
                root_dir = lspconfig.util.root_pattern(".pylintrc"),
            })
            lspconfig.r_language_server.setup({
                cmd = { "R", "--slave", "-e", "languageserver::run()" },
            })
        end
    }
}
