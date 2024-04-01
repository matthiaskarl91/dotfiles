return {
	jsonls = {
		settings = {
			json = {
				schema = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	terraformls = {
		cmd = { "terraform-ls" },
		arg = { "server" },
		filetypes = { "terraform", "tf", "terraform-vars" },
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					-- Tells lua_ls where to find all the Lua files that you have loaded
					-- for your neovim configuration.
					library = {
						"${3rd}/luv/library",
						unpack(vim.api.nvim_get_runtime_file("", true)),
					},
					-- If lua_ls is really slow on your computer, you can try this instead:
					-- library = { vim.env.VIMRUNTIME },
				},
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
	bashls = {
		filetypes = { "sh", "zsh" },
	},
	vimls = {
		filetypes = { "vim" },
	},
	tsserver = {
		--init_options = {
		--		plugins = {
		--			{
		--				name = "@vue/typescript-plugin",
		--				location = require("mason-registry").get_package("vue-language-server"):get_install_path()
		--					.. "/node_modules/@vue/language-server",
		--				languages = { "vue" },
		--			},
		--		},
		--	},
		-- filetypes = {
		--	"javascript",
		--	"typescript",
		--	"javascriptreact",
		--	"typescriptreact",
		--},
	},
	gopls = {},
	pyright = {},
	-- golangci_lint_ls = {},
	volar = {
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		init_options = {
			vue = {
				hybridMode = false,
			},
			typescript = {
				tsdk = vim.fn.getcwd() .. "node_modules/typescript",
			},
		},
	},
	solidity_ls_nomicfoundation = {},
	yamlls = {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml" },
	},
}