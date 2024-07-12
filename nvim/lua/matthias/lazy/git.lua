return {
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		config = function()
			local icons = require("matthias.config.icons")
			require("gitsigns").setup({
				signcolumn = true,
				numhl = false,
				linehl = true,
				word_diff = false,
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 100,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%d.%m.%Y> - <summary>",
				sign_priority = 6,
				status_formatter = nil,
				update_debounce = 200,
				max_file_length = 40000,
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},

				on_attach = function(bufnr)
					vim.keymap.set(
						"n",
						"<leader>H",
						require("gitsigns").preview_hunk,
						{ buffer = bufnr, desc = "Preview git hunk" }
					)

					vim.keymap.set("n", "]]", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Next git hunk" })

					vim.keymap.set(
						"n",
						"[[",
						require("gitsigns").prev_hunk,
						{ buffer = bufnr, desc = "Previous git hunk" }
					)
				end,
			})
		end,
		vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "GitSignsAdd" }),
		vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAddNr" }),
		vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignsAddLn" }),
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	},
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- not git, but it's okay
	"mbbill/undotree",
}
