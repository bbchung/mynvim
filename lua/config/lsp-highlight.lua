local M = {}
local cancel_timers = {}

function M.attach(bufnr)
    if cancel_timers[bufnr] then
        cancel_timers[bufnr]()
        return
    end
    local group = vim.api.nvim_create_augroup("LspHighlight" .. bufnr, { clear = true })
    local timer = assert(vim.uv.new_timer())
    local generation = 0

    local function cancel()
        generation = generation + 1
        timer:stop()
    end

    cancel_timers[bufnr] = cancel

    local function clear()
        if vim.api.nvim_buf_is_valid(bufnr) then
            vim.lsp.util.buf_clear_references(bufnr)
        end
    end

    local function on_timeout()
        local current = generation
        vim.schedule(function()
            if current ~= generation or vim.api.nvim_get_current_buf() ~= bufnr then
                return
            end
            if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentHighlight" }) > 0 then
                vim.lsp.buf.document_highlight()
            end
        end)
    end

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            generation = generation + 1
            clear()
            timer:start(200, 0, on_timeout)
        end,
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave", "LspDetach" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            cancel()
            clear()
        end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        buffer = bufnr,
        once = true,
        callback = function()
            cancel()
            timer:close()
            cancel_timers[bufnr] = nil
            vim.api.nvim_del_augroup_by_id(group)
        end,
    })
end

return M
