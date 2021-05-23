set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" 導入したいプラグインを以下に列挙
Plugin 'sgur/vim-editorconfig'

call vundle#end()
filetype plugin indent on

" line number
set number
" terminal title
set title
set tabstop=4
set smartindent
set whichwrap=b,s,[,],<,>
set expandtab
" 全角文字専用の設定
set ambiwidth=double
syntax on

"----------------------------------------
" ステータスライン
"----------------------------------------
" https://qiita.com/tashua314/items/101f1bec368c75a90251
" ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" これ以降は右寄せ表示
set statusline+=%=
" file encoding
set statusline+=[ENC=%{&fileencoding}]
" 現在行数/全行数
set statusline+=[LOW=%l/%L]
" ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2

"----------------------------------------
" 検索
"----------------------------------------
" 検索するときに大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視して検索
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set wrapscan
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索結果をハイライト表示
set hlsearch

"----------------------------------------
" ファイル名によってタブ幅を調整
"----------------------------------------
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 shiftwidth=2
augroup END

" コメントの色
hi Comment ctermfg=3

