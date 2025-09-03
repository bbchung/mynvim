return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
        "sainnhe/everforest",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
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
        "itchyny/vim-gitbranch",
    },
    {
        "itchyny/lightline.vim",
        config = function()
            vim.api.nvim_create_autocmd({"User"}, {
                pattern = {"CocStatusChange", "CocDiagnosticChange"},
                callback = function()
                    vim.cmd("redrawstatus")
                end,
            })

            -- Function equivalent to g:LightlineFugitive
            function _G.LightlineFugitive()
                local branch = vim.fn['gitbranch#name']()
                if branch ~= "" then
                    return "" .. branch
                else
                    return ""
                end
            end

            -- Lightline configuration
            vim.g.lightline = {
                colorscheme = "everforest",
                active = {
                    left = {
                        {"mode", "paste", "readonly"},
                        {"gitbranch"},
                        {"relativepath"},
                        {"modified"},
                    },
                    right = {
                        {"filetype"},
                        {"fileformat", "fileencoding"},
                        {"percent", "lineinfo"},
                        {"cocstatus", "codeium"},
                    },
                },
                inactive = {
                    left = {
                        {"mode", "paste", "readonly"},
                        {"gitbranch"},
                        {"relativepath"},
                        {"modified"},
                    },
                    right = {
                        {"filetype"},
                        {"fileformat", "fileencoding"},
                        {"percent", "lineinfo"},
                        {"cocstatus"},
                    },
                },
                component = {
                    paste = '%{&paste?"󰆒":""}',
                    readonly = '%{&readonly?"":""}',
                    relativepath = '%{expand("%:~:.")}',
                },
                component_function = {
                    gitbranch = "LightlineFugitive",
                    cocstatus = "coc#status",
                    codeium = "codeium#GetStatusString",
                },
                separator = {
                    left = "",
                    right = "",
                },
                subseparator = {
                    left = "|",
                    right = "|",
                },
            }
        end,
    },
    {
        "mhinz/vim-startify",
        config = function ()
            -- Startify settings
            vim.g.startify_session_persistence = 1
            vim.g.startify_change_to_dir = 0
            vim.g.startify_fortune_use_unicode = 1
            vim.g.startify_relative_path = 1

            -- Autocommand: enable cursorline when Startify buffer is loaded
            vim.api.nvim_create_autocmd("User", {
                pattern = "Startified",
                callback = function()
                    vim.opt_local.cursorline = true
                end,
            })
        end
    },
}
