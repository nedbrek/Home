set nocompatible " no vi stuff
" allow different settings by filetype
:filetype plugin on

" Perform a macro and save the last macro to g:LastMacro.
let g:LastMacro = ''
function! DoMacroSave()
    let l:macro = getchar()
    if l:macro =~ '^\d\+$'
        let l:macro = nr2char(l:macro)
    endif
    if l:macro != '@'
        let g:LastMacro = '@' .l:macro
    endif
    exec 'normal! @' . l:macro
endfunction
nnoremap <silent> @ :call DoMacroSave()<CR>

if has("tcl")
   tclfile ~/.vim.tcl
endif

" run make inside vi
:command -nargs=* Make make <args> | cwindow 3

set ruler " status bar
set showcmd " show current command sequence in right status bar
set rulerformat=%60(%F%r\ %{g:LastMacro}\ %l.%c,%L\ %p%%%)

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
set smartcase " upper case search only matches uppercase

