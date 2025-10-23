return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "toml",
                "json",
                "yaml",
                "python",
                "lua",
                "r",
                "c",
                "cpp",
                "cmake",
            },
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },

        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    },
}
