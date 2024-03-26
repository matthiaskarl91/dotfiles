return {
	mode = { "n", "v" },
	[";"] = { ":Alpha<CR>", "Dashboard" },
	w = { ":w!<CR>", "Save" },
	q = { ":confirm q<CR>", "Quit" },
	-- h = { ":nohlsearch<CR>", "No Highlight" },
	-- p = { require("telescope.builtin").lsp_document_symbols, "Document Symbols" },
	-- P = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols" },
	f = { require("matthias.config.utils").telescope_git_or_file, "Find Files (Root)" },
}
