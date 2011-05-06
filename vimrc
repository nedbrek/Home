set nocompatible " no vi stuff

" run make inside vi
:command -nargs=* Make make <args> | cwindow 3

set ruler " status bar
set showcmd " show current command sequence in right status bar

set showmatch " matching parens

syntax enable " highlighting

"alias uppercase commands
:command W w
:command Wq wq

" indentation
set autoindent
set smartindent

" turn it off for pasting
set pastetoggle=<F2>

set tabstop=3
set shiftwidth=3

" search
set nohlsearch " no highlight
set incsearch " incremental
set ignorecase " case insensitve search

