return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        init = function()
            -- Supply the options before the plugin attaches to the first buffer.
            vim.g.render_markdown_config = {
                completions = { lsp = { enabled = true } },
                html = { enabled = false },
                latex = { enabled = false },
            }
            -- Lazy's FileType handler would rerun all Markdown ftplugins.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                once = true,
                callback = function()
                    -- Tree-sitter skips the syntax loader that also defines the theme's Markdown highlights.
                    vim.cmd("runtime! syntax/markdown/*.{vim,lua}")
                    require("render-markdown")
                end,
            })
        end,
    },
}
