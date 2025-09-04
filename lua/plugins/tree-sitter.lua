return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Automatically update parsers when installing/updating
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "json",
                "lua",
                "markdown",
                "python",
                "vim",
                "yaml",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering a buffer
            auto_install = false,

            -- Enable syntax highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            -- Enable indentation (optional module)
            indent = {
                enable = true,
            },

        },
        config = function(plugin, opts)
            require("nvim-treesitter.configs").setup(opts)

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    },
}
