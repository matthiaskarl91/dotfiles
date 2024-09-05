return {
	{ "gd", vim.lsp.buf.definition, desc = "Goto definition" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
	{ "gi", vim.lsp.buf.implementation, desc = "Goto implementation" },
	{ "gl", vim.diagnostic.open_float, desc = "Goto float diagnostics" },
	{ "gr", vim.lsp.buf.references, desc = "Goto references" },
}
--vim.keymap.set("n", "<C-e>", function()
--		harpoon.ui:toggle_quick_menu(harpoon:list())
--	end)
