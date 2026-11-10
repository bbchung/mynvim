return {
	{
		"github/copilot.vim",
		enabled = true,
		event = "InsertEnter",
		cmd = "Copilot",
		init = function()
			vim.g.copilot_no_tab_map = true
		end,
		config = function()
			-- VimEnter/FileType may already have fired when InsertEnter loads Copilot.
			vim.fn["copilot#Init"]()
			vim.fn["copilot#OnFileType"]()
			vim.keymap.set("i", "<C-p>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.keymap.set("i", "<c-x>", "<Plug>(copilot-dismiss)", { silent = true })
			vim.keymap.set("i", "<c-l>", "<Plug>(copilot-next)", { silent = true })
			vim.keymap.set("i", "<c-h>", "<Plug>(copilot-previous)", { silent = true })
		end,
	},
	{
		"Exafunction/windsurf.vim",
		enabled = false,
		init = function()
			vim.g.codeium_no_map_tab = true
		end,
		config = function()
			vim.keymap.set("i", "<C-p>", "codeium#Accept()", {
				silent = true,
				expr = true,
			})

			vim.keymap.set("i", "<c-x>", "<Plug>(codeium-dismiss)", { silent = true })
			vim.keymap.set("i", "<c-l>", "<Plug>(codeium-next)", { silent = true })
			vim.keymap.set("i", "<c-h>", "<Plug>(codeium-previous)", { silent = true })
		end,
	},
}
