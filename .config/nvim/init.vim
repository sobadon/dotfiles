set mouse=a
set encoding=utf-8
set number
set ruler
set cursorline
set autoindent
set clipboard+=unnamedplus
set hls
set ignorecase
set smartcase
set incsearch
set title

set expandtab
" tab をスペース換算したときの幅
set tabstop=2
" tab 幅
set shiftwidth=2

syntax on

colorscheme industry

nnoremap <silent><C-e> :NERDTreeToggle<CR>
map <C-_> <Plug>Commentary

" , キーで次タブのバッファを表示
nnoremap <silent> , :bprev<CR>
" . キーで前タブのバッファを表示
nnoremap <silent> . :bnext<CR>
" bdで現在のバッファを削除
nnoremap bd :bd<CR>

let g:airline_theme='papercolor'
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1

" let g:indent_guides_enable_on_vim_startup = 1

nnoremap <silent> fzf :Files<CR>

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
