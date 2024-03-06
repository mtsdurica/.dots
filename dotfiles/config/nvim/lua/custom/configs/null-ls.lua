local null_ls = require("null-ls")

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	-- b.formatting.deno_fmt.with({
	-- 	filetypes ={
	--            "typescriptreact",
	--        },
	--        extra_args = {
	-- 		"--use_tabs",
	-- 	},
	-- }), -- choosed deno for ts/js files cuz its very fast!

	b.formatting.prettier.with({
		filetypes = {
            "typescriptreact",
			"html",
			"markdown",
			"css",
		},
		extra_args = function(params)
			return params.options and params.options.tabSize and {
				"--tab-width",
				params.options.tabSize,
			}
		end,
	}), -- so prettier works only on these filetypes

	-- Lua
	b.formatting.stylua,

	-- PHP
	b.formatting.phpcsfixer,

	-- cpp
	b.formatting.clang_format.with({
		extra_args = {
			"-style=Microsoft",
		},
	}),

	-- python
	b.formatting.black,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
