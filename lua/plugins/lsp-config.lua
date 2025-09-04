return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- capabilities for nvim-cmp
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- clangd setup
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = { "clangd", "--background-index", "--query-driver=/usr/bin/clang++", "--pch-storage=memory", "--clang-tidy" },
                filetypes = { "c", "cpp" },
                root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                filetypes = { "python" },
                root_dir = lspconfig.util.root_pattern(".pylintrc"),
            })

            local buf_map = function(mode, lhs, rhs, opts)
                opts = opts or { silent = true }
                vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
            end
            -- 常用 LSP 快捷鍵
            buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
            buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
            buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
            buf_map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")
        end
    }
}
