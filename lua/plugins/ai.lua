return {
    {
        "Exafunction/windsurf.vim",
        init = function()
            vim.g.codeium_no_map_tab = true
        end,
        config = function()

            vim.keymap.set("i", "<C-p>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true, nowait = true, script = true })
            vim.keymap.set("i", "<C-x>", "<Plug>(codeium-dismiss)", { silent = true })
            vim.keymap.set("i", "<C-l>", "<Plug>(codeium-next)", { silent = true })
            vim.keymap.set("i", "<C-h>", "<Plug>(codeium-previous)", { silent = true })
        end,
    },
}
