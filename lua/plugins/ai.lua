return {
    {
        "Exafunction/windsurf.vim",
        init = function()
            vim.g.codeium_no_map_tab = true
        end,
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set('i', '<C-k>', function() return vim.fn['codeium#Accept']() end,
                { expr = true, silent = true })
            vim.keymap.set('i', '<c-l>', function() return vim.fn['codeium#CycleCompletions'](1) end,
                { expr = true, silent = true })
            vim.keymap.set('i', '<c-h>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
                { expr = true, silent = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end,
                { expr = true, silent = true })
        end
    },
}
