return {
    {
        'L3MON4D3/LuaSnip',
        dependencies = { "rafamadriz/friendly-snippets", "honza/vim-snippets" },
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        enabled = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "honza/vim-snippets",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<A-y>"] = cmp.mapping(function(_)
                        luasnip.expand()
                    end, { "i", "s" }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<A-j>"] = cmp.mapping.select_next_item(),
                    ["<A-k>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "snippets" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },
    {
        'saghen/blink.cmp',
        enabled = true,
        dependencies = { 'L3MON4D3/LuaSnip' },
        build = 'cargo build --release',

        opts = {
            snippets = {
                preset = 'luasnip',
            },
            keymap = {
                preset = 'none',

                ['<C-y>'] = { 'select_and_accept', 'fallback' },
                ['<A-k>'] = { 'select_prev', 'fallback' },
                ['<A-j>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<C-e>'] = { 'hide', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono'
            },

            completion = { documentation = { auto_show = false } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            cmdline = {
                enabled = false,
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
    },
}
