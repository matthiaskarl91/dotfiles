return {
	mode = { "n", "v" },
	--[";"] = { ":Alpha<CR>", "Dashboard" },
	{ ";", ":Alpha<CR>", desc = "Dashboard" },
	{ "w", ":w!<CR>", desc = "Save" },
	{ "q", ":confirm q<CR>", desc = "Quit" },
	{
		"f",
		function()
			require("matthias.config.utils").telescope_git_or_file()
		end,
		desc = "Find Files (Root)",
	},
	{ "<leader>l", group = "+LSP" },
	{ "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
	{ "<leader>lA", vim.lsp.buf.range_code_action, desc = "Range Code Action" },
	{ "<leader>ls", vim.lsp.buf.signature_help, desc = "Display Signature Information" },
	{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename all references" },
	{ "<leader>lf", vim.lsp.buf.format, desc = "Format" },
	{
		"<leader>li",
		function()
			require("telescope.builtin").lsp_implementations()
		end,
		desc = "Implementation",
	},
	{ "<leader>ll", "<cmd>Trouble diagnostics toggle<cr>", desc = "Document Diagnostics (Trouble)" },
	{ "<leader>lL", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Workspace Diagnostics (Trouble)" },
	{
		"<leader>lw",
		function()
			require("telescope.builtin").diagnostics()
		end,
		desc = "Diagnostics",
	},
	{ "<leader>lW", group = "+Workspace" },
	{ "<leader>lWa", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" },
	{ "<leader>lWr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" },
	{
		"<leader>lWl",
		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		desc = "List Folder",
	},
	-- h = { ":nohlsearch<CR>", "No Highlight" },
	-- p = { require("telescope.builtin").lsp_document_symbols, "Document Symbols" },
	-- P = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols" },
	{ "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find File (CWD)" },
	{ "<leader>s", group = "+Search" },
	{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
	{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find highlight groups" },
	{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
	{ "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
	{ "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
	{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
	{ "<leader>sT", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
	{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
	{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
	{ "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
	{ "<leader>se", "<cmd>Telescope frecency<cr>", desc = "Frecency" },
	{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	{
		"<leader>sN",
		function()
			require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "Search Neovim Config",
	},
	{ "<leader>sd", group = "+DAP" },
	{ "<leader>sdc", "<cmd>Telescope dap commands<cr>", desc = "Dap Commands" },
	{ "<leader>sdb", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Dap Breakpoints" },
	{ "<leader>sdg", "<cmd>Telescope dap configurations<cr>", desc = "Dap Configurations" },
	{ "<leader>sdv", "<cmd>Telescope dap variables<cr>", desc = "Dap Variables" },
	{ "<leader>sdf", "<cmd>Telescope dap frames<cr>", desc = "Dap Frames" },
	{ "<leader>a", group = "harpoon" },
	{
		"<leader>aa",
		function()
			require("harpoon"):list():add()
		end,
		desc = "Append file in harpoon",
	},
	{
		"<leader>ae",
		function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Open harpoon menu",
	},
}
