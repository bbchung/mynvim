return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                default_integrations = true,
                no_italic = true,
                integrations = {
                    cmp = true,
                    treesitter = true,
                    mason = true,
                },
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
        "sainnhe/gruvbox-material",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.g.gruvbox_material_background = 'medium'
            vim.g.gruvbox_material_enable_italic = 0
            vim.g.gruvbox_material_disable_italic_comment = 1
            vim.g.gruvbox_material_sign_column_background = 'none'
        end,
    },
    {
        "sainnhe/everforest",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.g.everforest_background = 'medium'
            vim.g.everforest_enable_italic = 0
            vim.g.everforest_disable_italic_comment = 0
            vim.g.everforest_diagnostic_text_highlight = 1
            vim.g.everforest_diagnostic_line_highlight = 1
            vim.g.everforest_better_performance = 1
            vim.g.everforest_spell_foreground = 'colored'
        end,
    },
}
