return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = false },
            dashboard = {
                enabled = true,
                sections = {
                    { section = "keys", padding = 1 },
                    { title = "Recent Files", padding = 1 },
                    { section = "recent_files", limit = 8, padding = 1 },
                    { title = "Recent Files in Current Directory", padding = 1 },
                    { section = "recent_files", cwd = true, limit = 8, padding = 1 },
                },
            },
            explorer = { enabled = false },
            indent = { enabled = false },
            input = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            picker = {
                enabled = true,
                exclude = {
                    ".git",
                    "third_party",
                },
                layout = {
                    hidden = { "preview" },
                },
            },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- Wrap notifications
                },
            },
        },
        keys = {
            {
                "<leader>b",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>f",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>S",
                function()
                    Snacks.picker.grep()
                end,
                desc = "全專案關鍵字搜尋",
            },
            {
                "<leader>G",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "搜尋游標所在的單字",
            },
        },
    },
}
