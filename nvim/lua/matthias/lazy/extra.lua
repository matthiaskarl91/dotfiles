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
