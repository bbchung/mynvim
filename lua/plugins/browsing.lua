return {
    {
        'bbchung/gtags.vim',
        init = function()
            vim.g.Gtags_Auto_Update = 1
        end,
        config = function()
            -- Escape special characters for Gtags
            function _G.GtagsEscape(pattern)
                return pattern:gsub("[.*+?^$()|&;!#%%\\%[%] ]", "\\%1")
            end

            -- Normal mode mappings
            vim.keymap.set("n", "<Leader>s", ":GtagsCursor<CR>", { silent = true })

            vim.keymap.set("n", "<Leader>g", function()
                -- clear quickfix list
                vim.fn.setqflist({})
                local word = vim.fn.expand("<cword>")
                local cmd = string.format("Gtags -g %s", _G.GtagsEscape(word))
                vim.cmd(cmd)
                vim.cmd("copen")
            end, { silent = true })

            -- Visual mode mapping
            vim.keymap.set("v", "<Leader>g", function()
                vim.fn.setqflist({})
                local start_pos = vim.fn.getpos("'<")[2]
                local end_pos = vim.fn.getpos("'>")[2]
                local line = vim.fn.getline("'<")
                local selection = line:sub(start_pos, end_pos)
                local cmd = string.format("Gtags -g %s", _G.GtagsEscape(selection))
                vim.cmd(cmd)
                vim.cmd("copen")
            end, { silent = true })

            vim.schedule(function()
                vim.fn.system("global -qu")
            end)
        end
    },
    {
        'chrisbra/csv.vim',
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
        "tpope/vim-fugitive"
    },
}
