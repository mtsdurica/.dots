" github.com/bigguccimts

" Basic VIM stuff
:set number
:syntax on
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set encoding=utf-8
:set background=dark


" Plugin Installs
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ap/vim-css-color'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'jiangmiao/auto-pairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'sbdchd/neoformat'
Plug 'safv12/andromeda.vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
call plug#end()

:lua << END
require'lspconfig'.clangd.setup{}

vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require("bufferline").setup{
	options = {
		diagnostics = "nvim_lsp",
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
	    modified_icon = "⬤"
	}
}
END

" Keymaps
nnoremap <silent> <C-t> :NvimTreeToggle<CR>
nnoremap <silent> <S-M-f> :Neoformat<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <C-h> :BufferLineCyclePrev<CR>
nnoremap <silent> <C-j> :BufferLineCycleNext<CR>
nnoremap <silent> <C-s> :w<CR>
" nnoremap <silent> <C-w> :w \| bdelete<CR>

" Colorscheme
":colorscheme jellybeans
"let g:airline_theme = 'jellybeans'
:colorscheme molokai
let g:airline_theme = 'bubblegum'

" Airline config
let g:airline_powerline_fonts = 1

" Terminal config
let g:Terminal_InsertOnEnter = 1
let g:Terminal_CloseOnEnd = 1
let g:Terminal_CWInsert = 1
let g:Terminal_StartMessages = 0

" Formatter config
let g:neoformat_c_clangformat = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=Microsoft'],
			\ }
let g:neoformat_cpp_clangformat = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=Microsoft'],
            \ }
let g:shfmt_opt="-ci"
let g:neoformat_only_msg_on_error = 1
" Formatting on save
augroup fmt
  autocmd!
  autocmd BufWrite * undojoin | :Neoformat
augroup END

" Indent config
set termguicolors
" For jellybeans
"highlight IndentBlanklineIndent1 guibg=#151515 blend=nocombine
"highlight IndentBlanklineIndent2 guibg=#222222 blend=nocombine
" For andromeda
"highlight IndentBlanklineIndent1 guibg=#23262e blend=nocombine
"highlight IndentBlanklineIndent2 guibg=#383b42 blend=nocombine

let g:indent_blankline_char = ""
let g:indent_blankline_char_highlight_list = ["IndentBlanklineIndent1", "IndentBlanklineIndent2"]
let g:indent_blankline_space_char_highlight_list = ["IndentBlanklineIndent1", "IndentBlanklineIndent2"]
let g:indent_blankline_show_trailing_blankline_indent = v:false

