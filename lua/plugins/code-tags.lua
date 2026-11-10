return {
    {
        "bbchung/gtags.vim",
        enabled = true,
        lazy = false,
        init = function()
            vim.g.Gtags_Auto_Update = 0
        end,
        config = function()
            -- Escape special characters for Gtags
            local function GtagsEscape(pattern)
                return vim.fn.escape(pattern, "{}[]()^$.*+?-|%")
            end

            local function run_gtags_search(pattern)
                vim.cmd("Gtags -g " .. GtagsEscape(pattern))
                vim.cmd("copen")
            end

            -- Normal mode mappings
            vim.keymap.set("n", "<Leader>s", ":GtagsCursor<CR>", { silent = true })

            vim.keymap.set("n", "<Leader>g", function()
                local word = vim.fn.expand("<cword>")
                run_gtags_search(word)
            end, { silent = true })

            vim.keymap.set("x", "<Leader>g", function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
                local bufnr = vim.api.nvim_get_current_buf()
                local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
                local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")

                if start_pos[1] ~= end_pos[1] then
                    vim.notify("Gtags: Multiline selection not supported", vim.log.levels.WARN)
                    return
                end

                local selected_text = vim.api.nvim_buf_get_text(
                    bufnr,
                    start_pos[1] - 1,
                    start_pos[2],
                    end_pos[1] - 1,
                    end_pos[2] + 1,
                    {}
                )[1]
                if not selected_text then
                    return
                end
                run_gtags_search(selected_text)
            end, { silent = true })

            local queue = {}
            local pending = {}
            local running = false

            local function start_next()
                if running or #queue == 0 then
                    return
                end
                local job = table.remove(queue, 1)
                pending[job.key] = nil
                running = true
                local id = vim.fn.jobstart(job.cmd, {
                    cwd = job.cwd,
                    on_exit = function()
                        running = false
                        start_next()
                    end,
                })
                if id <= 0 then
                    running = false
                    vim.notify("Gtags: failed to start global", vim.log.levels.WARN)
                    start_next()
                end
            end

            local function update_tags(file)
                if vim.fn.executable("global") ~= 1 then
                    return
                end
                local path = file and vim.fs.dirname(file) or vim.fn.getcwd()
                local database = vim.fs.find("GTAGS", { path = path, upward = true, type = "file" })[1]
                if not database then
                    return
                end
                local root = vim.fs.dirname(database)
                local key = root .. "\n" .. (file or "")
                if pending[key] then
                    return
                end
                pending[key] = true
                queue[#queue + 1] = {
                    key = key,
                    cwd = root,
                    cmd = file and { "global", "-u", "--single-update", file } or { "global", "-uv" },
                }
                start_next()
            end

            update_tags()
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = vim.api.nvim_create_augroup("GtagsUpdate", { clear = true }),
                pattern = { "*.c", "*.cpp", "*.cc", "*.h", "*.hpp" },
                callback = function(args)
                    update_tags(args.file)
                end,
            })
        end,
    },
}
