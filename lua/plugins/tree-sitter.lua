return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        ensure_installed = { "c", "cpp", "python", "lua", "vimdoc", "bash" }, -- languages you want
        highlight = {
            enable = true,              -- false will disable the whole extension
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        },
        config = function()
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    }
}
