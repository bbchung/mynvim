return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Automatically update parsers when installing/updating
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
        config = function(_, opts)
            if vim.o.diff then
                return
            end

            require("nvim-treesitter.configs").setup(opts)

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    },
}
