return {
    {
        'everviolet/nvim',
        name = 'evergarden',
        priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
        opts = {
            theme = {
                variant = 'fall', -- 'winter'|'fall'|'spring'|'summer'
                accent = 'green',
            },
            editor = {
                transparent_background = false,
                sign = { color = 'none' },
                float = {
                    color = 'mantle',
                    solid_border = false,
                },
                completion = {
                    color = 'surface0',
                },
            },
        }
    },
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
        "vague2k/vague.nvim",
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000,
    },
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_enable_italic = 0
            vim.g.gruvbox_material_disable_italic_comment = 0
            vim.g.gruvbox_material_diagnostic_text_highlight = 1
            vim.g.gruvbox_material_diagnostic_line_highlight = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_spell_foreground = 'colored'
            vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'
            vim.g.gruvbox_material_current_word = 'high contrast background'
        end,
    },
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_background = 'hard'
            vim.g.everforest_enable_italic = 0
            vim.g.everforest_disable_italic_comment = 0
            vim.g.everforest_diagnostic_text_highlight = 1
            vim.g.everforest_diagnostic_line_highlight = 1
            vim.g.everforest_better_performance = 1
            vim.g.everforest_spell_foreground = 'colored'
            vim.g.everforest_diagnostic_virtual_text = 'highlighted'
            vim.g.everforest_current_word = 'high contrast background'
        end,
    },
}
