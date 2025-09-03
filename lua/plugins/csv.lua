return {
    {
        'chrisbra/csv.vim',
        config = function ()
            -- CSV plugin settings
            vim.g.no_csv_maps = 1
            vim.g.csv_no_progress = 1

            -- Start and end variables
            vim.g.start = 1
            vim.g["end"] = 10   -- 'end' is a Lua keyword, so use string indexing
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
    }
}
