return {
    {
        'bbchung/gtags.vim',
        init = function()
            vim.g.Gtags_Auto_Update = 0
        end,
        config = function()
            -- Escape special characters for Gtags
            function GtagsEscape(pattern)
                return pattern:gsub("[.*+?^$()|&;!#%%\\%[%] ]", "\\%1")
            end

            -- Normal mode mappings
            vim.keymap.set("n", "<Leader>s", ":GtagsCursor<CR>", { silent = true })

            vim.keymap.set("n", "<Leader>g", function()
                -- clear quickfix list
                vim.fn.setqflist({})
                local word = vim.fn.expand("<cword>")
                local cmd = string.format("Gtags -g %s", GtagsEscape(word))
                vim.cmd(cmd)
                vim.cmd("copen")
            end, { silent = true })

            vim.keymap.set("x", "<Leader>g", function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
                vim.fn.setqflist({})
                local bufnr         = vim.api.nvim_get_current_buf()
                local start_pos     = vim.api.nvim_buf_get_mark(bufnr, "<")
                local end_pos       = vim.api.nvim_buf_get_mark(bufnr, ">")
                local line          = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, start_pos[1], true)[1]
                local selected_text = string.sub(line, start_pos[2] + 1, end_pos[2] + 1)
                vim.cmd(string.format("Gtags -g %s", GtagsEscape(selected_text)))
                vim.cmd("copen")
            end, { silent = true })

            local current_job = nil
            local queued_job = nil -- only keep the last queued request

            local function run_async_singleton(cmd)
                local function start_job()
                    current_job = vim.fn.jobstart(cmd, {
                        on_exit = function(_, _, _)
                            current_job = nil
                            if queued_job then
                                local next_job = queued_job
                                queued_job = nil
                                next_job()
                            end
                        end,
                    })
                end

                if current_job then
                    queued_job = start_job
                else
                    start_job()
                end
            end

            run_async_singleton({ "global", "-uv" })
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
                callback = function()
                    local bufname = vim.api.nvim_buf_get_name(0)
                    run_async_singleton({ "global", "-u", "--single-update", bufname })
                end,
            })
        end
    },
}
