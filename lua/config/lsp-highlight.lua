local M = {}
local cleanups = {}

function M.attach(bufnr)
    if cleanups[bufnr] then
        cleanups[bufnr]()
    end
    local group = vim.api.nvim_create_augroup("LspHighlight" .. bufnr, { clear = true })
    local timer
    local generation = 0

    local function cancel()
        generation = generation + 1
        if timer then
            vim.fn.timer_stop(timer)
            timer = nil
        end
    end

    cleanups[bufnr] = cancel

    local function clear()
        cancel()
        if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_call(bufnr, vim.lsp.buf.clear_references)
        end
    end

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            clear()
            local current = generation
            timer = vim.fn.timer_start(200, function()
                timer = nil
                if current ~= generation or vim.api.nvim_get_current_buf() ~= bufnr then
                    return
                end
                if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentHighlight" }) > 0 then
                    vim.lsp.buf.document_highlight()
                end
            end)
        end,
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave" }, {
        group = group,
        buffer = bufnr,
        callback = clear,
    })
    vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        buffer = bufnr,
        callback = clear,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        buffer = bufnr,
        once = true,
        callback = function()
            cancel()
            cleanups[bufnr] = nil
            vim.api.nvim_del_augroup_by_id(group)
        end,
    })
end

return M
