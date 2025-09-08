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


vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<F3>", ":bd!<CR>", { silent = true })
vim.keymap.set("n", "<F4>", ":qa!<CR>", { silent = true })
vim.keymap.set("t", "<F4>", "<C-\\><C-N>:qa!<CR>", { silent = true })
vim.keymap.set("n", "<F5>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<F6>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<F7>", ":cp<CR>", { silent = true })
vim.keymap.set("n", "<F8>", ":cn<CR>", { silent = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", { noremap = true })

vim.api.nvim_create_user_command("W", "silent w !sudo > /dev/null tee %", {})
vim.api.nvim_create_user_command("Diagnostics", function()
    vim.diagnostic.setqflist({ open = true })
end, { desc = "Open all LSP diagnostics in quickfix" })

local augroup = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

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

require("config.lazy")

if vim.opt.diff:get() then
    vim.cmd("syntax off")
end

vim.cmd.colorscheme("everforest")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" },
  callback = function()
    vim.cmd("CsvViewEnable")
  end,
})

