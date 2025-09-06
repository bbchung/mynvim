return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
        "sainnhe/gruvbox-material",
        lazy = true,
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
        lazy = true,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.g.everforest_background = 'medium'
            vim.g.everforest_enable_italic = 0
            vim.g.everforest_disable_italic_comment = 0
            vim.g.everforest_sign_column_background = 'none'
            vim.g.everforest_diagnostic_text_highlight = 1
            vim.g.everforest_diagnostic_line_highlight = 0
            vim.g.everforest_better_performance = 1
            vim.g.everforest_spell_foreground = 'colored'
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                        refresh_time = 16, -- ~60fps
                        events = {
                            'WinEnter',
                            'BufEnter',
                            'BufWritePost',
                            'SessionLoadPost',
                            'FileChangedShellPost',
                            'VimResized',
                            'Filetype',
                            'CursorMoved',
                            'CursorMovedI',
                            'ModeChanged',
                        },
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', { 'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        symbols = {
                            error = ' ',
                            warn  = ' ',
                            info  = ' ',
                            hint  = ' ',
                        },
                        colored = true, -- Use highlight groups
                    }
                    },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end
    },
}
