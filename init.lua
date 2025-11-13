vim.g.mapleader = "\\"

vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.background = "dark"
vim.opt.foldlevelstart = 99
vim.opt.termguicolors = true
vim.opt.signcolumn = "number"
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.matchpairs:append("<:>")
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 16
vim.opt.smartindent = true
local undo_dir = vim.fn.stdpath("config") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir


vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    virtual_text = { current_line = true },
    severity_sort = true,
})

for _, m in ipairs { 'n', 'i', 'v', 'x', 'o', 'c' } do vim.keymap.set(m, '<C-c>', '<Esc>',
        { noremap = true, silent = true }) end
vim.keymap.set("n", "<F3>", ":bd!<CR>", { silent = true })
vim.keymap.set("n", "<F4>", ":qa!<CR>", { silent = true })
vim.keymap.set("t", "<F4>", "<C-\\><C-N>:qa!<CR>", { silent = true })
vim.keymap.set("n", "<F5>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<F6>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<F7>", ":cn<CR>", { silent = true })
vim.keymap.set("n", "<F8>", ":cp<CR>", { silent = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", { noremap = true })
vim.keymap.set("n", "<Leader>G", function()
    vim.cmd(string.format("silent grep! %s `git ls-files`", vim.fn.expand("<cword>")))
    vim.cmd("copen")
end, { silent = true })

vim.keymap.set('x', '<leader>G', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    local bufnr         = vim.api.nvim_get_current_buf()
    local start_pos     = vim.api.nvim_buf_get_mark(bufnr, "<")
    local end_pos       = vim.api.nvim_buf_get_mark(bufnr, ">")
    local line          = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, start_pos[1], true)[1]
    local selected_text = string.sub(line, start_pos[2] + 1, end_pos[2] + 1)

    --local save_reg     = vim.fn.getreg('"')
    --local save_regtype = vim.fn.getregtype('"')
    --vim.cmd('normal! "vy')
    --local selected_text = vim.fn.getreg('"')
    --vim.fn.setreg('"', save_reg, save_regtype)

    vim.cmd('silent grep! -F ' .. vim.fn.shellescape(selected_text) .. ' `git ls-files`')
    vim.cmd('copen')
end, { silent = true })
vim.api.nvim_create_user_command("W", "silent w !sudo > /dev/null tee %", {})
vim.api.nvim_create_user_command("Diagnostics", function()
    vim.diagnostic.setqflist({ open = true })
end, { desc = "Open all LSP diagnostics in quickfix" })

require("config.lazy")

local augroup = vim.api.nvim_create_augroup("UserAutoCmd", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    pattern = "*",
    command = "startinsert",
})

if vim.o.diff then
    vim.cmd("TSDisable highlight")
    vim.cmd("syntax off")
    vim.opt.readonly = false
end

vim.cmd.colorscheme("vague")
