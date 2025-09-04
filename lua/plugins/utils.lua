return {
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig", {
            "mason-org/mason.nvim",
        } },

        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls" },
            }
            )
        end,
    },
}
