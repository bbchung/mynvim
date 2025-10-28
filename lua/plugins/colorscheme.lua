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
                auto_integrations = true,
                no_italic = true,
            })
        end,
    },
    {
        "vague2k/vague.nvim",
        priority = 1000,
        config = function()
            require("vague").setup({
                bold = false,
            })
        end
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
            vim.g.gruvbox_material_disable_italic_comment = 1
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
            vim.g.everforest_disable_italic_comment = 1
            vim.g.everforest_diagnostic_text_highlight = 1
            vim.g.everforest_diagnostic_line_highlight = 1
            vim.g.everforest_better_performance = 1
            vim.g.everforest_spell_foreground = 'colored'
            vim.g.everforest_diagnostic_virtual_text = 'highlighted'
            vim.g.everforest_current_word = 'high contrast background'
        end,
    },
    {
        "sainnhe/edge",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.edge_background = 'hard'
            vim.g.edge_enable_italic = 0
            vim.g.edge_disable_italic_comment = 1
            vim.g.edge_diagnostic_text_highlight = 1
            vim.g.edge_diagnostic_line_highlight = 1
            vim.g.edge_better_performance = 1
            vim.g.edge_spell_foreground = 'colored'
            vim.g.edge_diagnostic_virtual_text = 'highlighted'
            vim.g.edge_current_word = 'high contrast background'
        end,
    },
    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.sonokai_background = 'hard'
            vim.g.sonokai_enable_italic = 0
            vim.g.sonokai_disable_italic_comment = 1
            vim.g.sonokai_diagnostic_text_highlight = 1
            vim.g.sonokai_diagnostic_line_highlight = 1
            vim.g.sonokai_better_performance = 1
            vim.g.sonokai_spell_foreground = 'colored'
            vim.g.sonokai_diagnostic_virtual_text = 'highlighted'
            vim.g.sonokai_current_word = 'high contrast background'
        end,
    },
}
