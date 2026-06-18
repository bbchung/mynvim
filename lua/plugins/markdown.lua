return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            completions = {
                lsp = { enabled = true },
            },
            html = { enabled = false },
            latex = { enabled = false },
        },
    },
}
