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

            -- Visual mode mapping
            vim.keymap.set("v", "<Leader>g", function()
                vim.fn.setqflist({})
                local save_reg = vim.fn.getreg('"')
                local save_regtype = vim.fn.getregtype('"')

                -- Yank visual selection into unnamed register
                vim.cmd('normal! "vy')

                -- Get yanked text
                local selected_text = vim.fn.getreg('"')
                vim.fn.setreg('"', save_reg, save_regtype)
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
