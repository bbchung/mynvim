return {
    {
        "liuchengxu/vim-clap",
        build = ":Clap install-binary",   -- builds the Rust binary after install
        config = function()
            vim.keymap.set("n", "<Leader>F", ":Clap gfiles<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>f", ":Clap files --name-only<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>b", ":Clap buffers<CR>", { silent = true })

            -- Settings (vim.g for g: variables)
            vim.g.clap_open_preview = "never"
            -- vim.g.clap_layout = { relative = "editor" } -- commented out
            vim.g.clap_popup_input_delay = 0
            vim.g.clap_disable_run_rooter = true
            vim.g.clap_enable_icon = 0
        end,
    }
}
