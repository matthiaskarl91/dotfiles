return {
	mode = { "n", "v" },
	[";"] = { ":Alpha<CR>", "Dashboard" },
	w = { ":w!<CR>", "Save" },
	q = { ":confirm q<CR>", "Quit" },
	-- h = { ":nohlsearch<CR>", "No Highlight" },
	-- p = { require("telescope.builtin").lsp_document_symbols, "Document Symbols" },
	-- P = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols" },
	f = { require("matthias.config.utils").telescope_git_or_file, "Find Files (Root)" },
	l = {
		name = "+LSP",
		a = { vim.lsp.buf.code_action, "Code Action" },
		A = { vim.lsp.buf.range_code_action, "Range Code Actions" },
		s = { vim.lsp.buf.signature_help, "Display Signature Information" },
		r = { vim.lsp.buf.rename, "Rename all references" },
		f = { vim.lsp.buf.format, "Format" },
		i = { require("telescope.builtin").lsp_implementations, "Implementation" },
		l = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
		L = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
		w = { require("telescope.builtin").diagnostics, "Diagnostics" },
		-- t = { require("telescope").extensions.refactoring.refactors, "Refactor" },
		W = {
			name = "+Workspace",
			a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
			r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
			l = {
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				"List Folders",
			},
		},
	},
	s = {
		name = "+Search",
		f = { "<cmd>Telescope find_files<cr>", "Find File (CWD)" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		t = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		T = { "<cmd>Telescope grep_string<cr>", "Grep String" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		l = { "<cmd>Telescope resume<cr>", "Resume last search" },
		c = { "<cmd>Telescope git_commits<cr>", "Git commits" },
		B = { "<cmd>Telescope git_branches<cr>", "Git branches" },
		m = { "<cmd>Telescope git_status<cr>", "Git status" },
		S = { "<cmd>Telescope git_stash<cr>", "Git stash" },
		e = { "<cmd>Telescope frecency<cr>", "Frecency" },
		b = { "<cmd>Telescope buffers<cr>", "Buffers" },
		d = {
			name = "+DAP",
			c = { "<cmd>Telescope dap commands<cr>", "Dap Commands" },
			b = { "<cmd>Telescope dap list_breakpoints<cr>", "Dap Breakpoints" },
			g = { "<cmd>Telescope dap configurations<cr>", "Dap Configurations" },
			v = { "<cmd>Telescope dap variables<cr>", "Dap Variables" },
			f = { "<cmd>Telescope dap frames<cr>", "Dap Frames" },
		},
		N = {
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			"Search Neovim Config",
		},
	},
	a = {
		a = {
			function()
				require("harpoon"):list():add()
			end,
			"Append file in harpoon",
		},
		e = {
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			"Open harpoon menu",
		},
	},
}
