return {
    {
        'bbchung/gtags.vim',
        lazy = false,
        init = function ()
            vim.g.Gtags_Auto_Update = 1
        end,
        config = function ()
            -- Escape special characters for Gtags
            function _G.GtagsEscape(pattern)
                -- equivalent of Vim's substitute(pattern, '\v[.*+?^$()|&;!#%\\\[\] ]', '\\&', 'g')
                return pattern:gsub("[.*+?^$()|&;!#%%\\%[%] ]", "\\%1")
            end


            -- Normal mode mappings
            vim.keymap.set("n", "<Leader>s", ":GtagsCursor<CR>", { silent = true })

            vim.keymap.set("n", "<Leader>g", function()
                -- clear quickfix list
                vim.fn.setqflist({})
                -- get current word and escape it
                local word = vim.fn.expand("<cword>")
                local cmd = string.format("Gtags -g %s", _G.GtagsEscape(word))
                -- execute the command
                vim.cmd(cmd)
                -- open quickfix
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

            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.fn.system("global -qu")
                end,
            })
        end
    }
}
