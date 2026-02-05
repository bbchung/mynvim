return {
    {
        "mhinz/vim-startify",
        lazy = false,
        enabled = false,
        config = function()
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
    {
        "goolord/alpha-nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local startify = require("alpha.themes.startify")
            -- available: devicons, mini, default is mini
            -- if provider not loaded and enabled is true, it will try to use another provider
            startify.file_icons.provider = "devicons"
            --  require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
            require("alpha").setup(startify.config)
        end,
    },
}
