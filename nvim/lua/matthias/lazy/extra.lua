return {
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				stop_eof = true,
				easing_function = "sine",
				hide_cursor = true,
				cursor_scrolls_alone = true,
			})
		end,
	},
	{
		"vuki656/package-info.nvim",
		config = function()
			require("package-info").setup()
			-- Show dependency versions
			vim.keymap.set({ "n" }, "<LEADER>ns", require("package-info").show, { silent = true, noremap = true })
			-- Hide dependency versions
			vim.keymap.set({ "n" }, "<LEADER>nc", require("package-info").hide, { silent = true, noremap = true })
			-- Toggle dependency versions
			vim.keymap.set({ "n" }, "<LEADER>nt", require("package-info").toggle, { silent = true, noremap = true })
			-- Update dependency on the line
			vim.keymap.set({ "n" }, "<LEADER>nu", require("package-info").update, { silent = true, noremap = true })
			-- Delete dependency on the line
			vim.keymap.set({ "n" }, "<LEADER>nd", require("package-info").delete, { silent = true, noremap = true })
			-- Install a new dependency
			vim.keymap.set({ "n" }, "<LEADER>ni", require("package-info").install, { silent = true, noremap = true })
			-- Install a different dependency version
			vim.keymap.set(
				{ "n" },
				"<LEADER>np",
				require("package-info").change_version,
				{ silent = true, noremap = true }
			)
		end,
	},
	-- persist sessions
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {},
	},
	-- Simple winbar/statusline plugin that shows your current code context
	{
		"SmiteshP/nvim-navic",
		config = function()
			local icons = require("matthias.config.icons")
			require("nvim-navic").setup({
				highlight = true,
				lsp = {
					auto_attach = true,
					preference = { "typescript-tools" },
				},
				click = true,
				separator = " " .. icons.ui.ChevronRight .. " ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
			})
		end,
	},
}
