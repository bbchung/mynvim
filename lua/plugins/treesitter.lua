return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "bash", "toml", "json", "yaml", "python", "lua", "r", "c", "cpp", "cmake" },
                callback = function()
                    vim.treesitter.start()
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                    },
                    include_surrounding_whitespace = false,
                },
            })

            for _, mapping in ipairs({
                { "am", "@function.outer", "textobjects" },
                { "im", "@function.inner", "textobjects" },
                { "ac", "@class.outer", "textobjects" },
                { "ic", "@class.inner", "textobjects" },
                { "as", "@local.scope", "locals" },
            }) do
                local key, capture, query_group = unpack(mapping)
                vim.keymap.set({ "x", "o" }, key, function()
                    require("nvim-treesitter-textobjects.select").select_textobject(capture, query_group)
                end)
            end

            require("nvim-treesitter-textobjects").setup({
                move = { set_jumps = true },
            })

            for _, mapping in ipairs({
                { "]m", "goto_next_start", "@function.outer", "textobjects" },
                { "]]", "goto_next_start", "@class.outer", "textobjects" },
                { "]o", "goto_next_start", { "@loop.inner", "@loop.outer" }, "textobjects" },
                { "]s", "goto_next_start", "@local.scope", "locals" },
                { "]z", "goto_next_start", "@fold", "folds" },
                { "]M", "goto_next_end", "@function.outer", "textobjects" },
                { "][", "goto_next_end", "@class.outer", "textobjects" },
                { "[m", "goto_previous_start", "@function.outer", "textobjects" },
                { "[[", "goto_previous_start", "@class.outer", "textobjects" },
                { "[M", "goto_previous_end", "@function.outer", "textobjects" },
                { "[]", "goto_previous_end", "@class.outer", "textobjects" },
                { "]d", "goto_next", "@conditional.outer", "textobjects" },
                { "[d", "goto_previous", "@conditional.outer", "textobjects" },
            }) do
                local key, method, capture, query_group = unpack(mapping)
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    require("nvim-treesitter-textobjects.move")[method](capture, query_group)
                end)
            end
        end,
    },
}
