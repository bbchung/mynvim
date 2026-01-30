return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "master",
        },
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
            textobjects = {
                select = {
                    enable = true,
                    -- 發現目標時是否自動跳轉游標
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["ai"] = "@conditional.outer",
                        ["ii"] = "@conditional.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- 是否在跳轉清單紀錄位置
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
            },

        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    },
}
