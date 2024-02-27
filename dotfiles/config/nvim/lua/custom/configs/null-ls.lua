local null_ls = require("null-ls")

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
	b.formatting.prettier.with({
		filetypes = {
			"html",
			"markdown",
			"css",
		},
		extra_args = function(params)
			return params.options and params.options.tabSize and {
				"--tab-width",
                params.options.tabSize
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

	b.formatting.black,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
