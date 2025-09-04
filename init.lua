vim.g.mapleader = "\\"
vim.opt.number = true
vim.opt.background = "dark"
vim.opt.foldlevelstart = 99
vim.opt.termguicolors = true
vim.opt.signcolumn = "number"
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.matchpairs:append("<:>")
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })
-- Persistent undo
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.api.nvim_create_user_command("W", function()
    vim.cmd("silent w !sudo > /dev/null tee %")
end, {})

vim.keymap.set("n", "<F3>", ":bd!<CR>", { silent = true })
vim.keymap.set("n", "<F4>", ":qa!<CR>", { silent = true })
vim.keymap.set("t", "<F4>", "<C-\\><C-N>:qa!<CR>", { silent = true })
vim.keymap.set("n", "<F5>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<F6>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<F7>", ":cp<CR>", { silent = true })
vim.keymap.set("n", "<F8>", ":cn<CR>", { silent = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", { noremap = true })

local undo_dir = vim.fn.stdpath("config") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"') -- last cursor position
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] >= 1 and mark[1] <= lcount then
            vim.cmd([[normal! g`"]])
        end
    end,
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN]  = '',
            [vim.diagnostic.severity.INFO]  = '',
            [vim.diagnostic.severity.HINT]  = '',
        },
    },
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

require("config.lazy")

-- Automatically enter insert mode when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
    end,
})

vim.cmd.colorscheme("everforest")
