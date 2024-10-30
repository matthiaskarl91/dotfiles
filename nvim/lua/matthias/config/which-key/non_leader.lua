return {
	{ "gd", require("telescope.builtin").lsp_definitions, desc = "Goto definition" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
	{ "gi", vim.lsp.buf.implementation, desc = "Goto implementation" },
	{ "gl", vim.diagnostic.open_float, desc = "Goto float diagnostics" },
	{ "gr", vim.lsp.buf.references, desc = "Goto references" },
	{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
}
--nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
--vim.keymap.set("n", "<C-e>", function()
--		harpoon.ui:toggle_quick_menu(harpoon:list())
--	end)
