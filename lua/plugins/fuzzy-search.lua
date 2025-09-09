return {
    {
        "liuchengxu/vim-clap",
        build = ":Clap install-binary", -- builds the Rust binary after install
        enabled = false,
        config = function()
            vim.keymap.set("n", "<Leader>F", ":Clap gfiles<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>f", ":Clap files --name-only<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>b", ":Clap buffers<CR>", { silent = true })

            vim.g.clap_open_preview = "never"
            vim.g.clap_popup_input_delay = 0
            vim.g.clap_disable_run_rooter = true
            vim.g.clap_enable_icon = 0
        end,
    },
    {
        "Yggdroot/LeaderF",
        build = ":LeaderfInstallCExtension",
        enabled = false,
        config = function()
            vim.g.Lf_WildIgnore = {
                dir = { ".*", "build", "third_party", ".clangd", "fuxi.run*" },
                file = { "*.sw?", "~$*", "*.bak", "*.exe", "*.o", "*.so", "*.py[co]" },
            }

            -- UI and behavior settings
            vim.g.Lf_StlColorscheme = "everforest"
            vim.g.Lf_WindowHeight = 0.3
            vim.g.Lf_PopupHeight = 0.6
            vim.g.Lf_RecurseSubmodules = 1
            vim.g.Lf_GtagsAutoGenerate = 0
            vim.g.Lf_GtagsAutoUpdate = 0
            vim.g.Lf_GtagsStoreInProject = 0
            vim.g.Lf_DefaultExternalTool = "fd"
            vim.g.Lf_UseVersionControlTool = 1
            vim.g.Lf_DefaultMode = "NameOnly"
            vim.g.Lf_WindowPosition = "popup"
            vim.g.Lf_PreviewInPopup = 0
            vim.g.Lf_PopupPreviewPosition = "bottom"
            vim.g.Lf_CursorBlink = 0
            vim.g.Lf_PopupShowStatusline = 0
            vim.g.Lf_StlSeparator = { left = "", right = "" }
            vim.g.Lf_ShowDevIcons = 0
            vim.g.Lf_WorkingDirectoryMode = "a"

            -- Preview result settings
            vim.g.Lf_PreviewResult = {
                File = 0,
                Buffer = 0,
                Mru = 0,
                Tag = 0,
                BufTag = 0,
                Function = 1,
                Line = 0,
                Colorscheme = 0,
                Rg = 0,
                Gtags = 0,
            }

            -- Ripgrep config
            vim.g.Lf_RgConfig = { "--glob=!third_party/*" }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
        config = function()
            vim.keymap.set("n", "<Leader>F", ":Telescope git_files<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>f", ":Telescope find_files<CR>", { silent = true })
            vim.keymap.set("n", "<Leader>b", ":Telescope buffers<CR>", { silent = true })

            require('telescope').setup {
                pickers = {
                    find_files = {
                        entry_maker = function(filepath)
                            local entry = require("telescope.make_entry").gen_from_file()(filepath)
                            entry.ordinal = vim.fn.fnamemodify(filepath, ":t")
                            return entry
                        end
                    },
                    buffers = {
                        sort_lastused = true,
                        sorter = nil,
                    }
                },
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                        },
                        n = {
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                        },
                    },
                    preview = false,
                    layout_config = {
                        prompt_position = "top",
                        width = 0.5,
                        height = 0.6,
                    },
                    sorting_strategy = "ascending",
                    file_ignore_patterns = { "third_party/" },
                },
            }
            require('telescope').load_extension('fzf')
        end
    }
}
