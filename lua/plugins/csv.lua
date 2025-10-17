return {
    {
        'chrisbra/csv.vim',
        enabled = false,
        init = function()
            vim.g.no_csv_maps = 1
        end,
        config = function()
            -- CSV plugin settings
            vim.g.csv_no_progress = 1

            -- Start and end variables
            vim.g.start = 1
            vim.g["end"] = 10 -- 'end' is a Lua keyword, so use string indexing
            -- Define the formatting function
            function _G.CsvFormat()
                vim.cmd("'<,'>ArrangeColumn")
                return 0
            end

            -- Set formatexpr for CSV files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "csv",
                callback = function()
                    vim.opt_local.formatexpr = "v:lua.CsvFormat()"
                end,
            })
        end
    },
    {
        "hat0uma/csvview.nvim",
        ft = "csv",
        opts = {
            parser = { comments = { "#", "//" } },
            view = {
                display_mode = "border",
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
        config = function(_, opts)
            require("csvview").setup(opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "csv", "tsv" },
                callback = function()
                    vim.cmd("CsvViewEnable")
                end,
            })
        end,
    },
    {
        "tpope/vim-fugitive"
    },
}
