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

" find in files
:command Find :lex system("git grep -n " . shellescape(getreg('/')))

set ruler " status bar
set showcmd " show current command sequence in right status bar
set rulerformat=%60(%F%r\ %{g:LastMacro}\ %l.%v,%L\ %p%%%)

" some installations require command height of 2 (not sure why)
"set cmdheight=2 " for output of scripts (no press enter)

set showmatch " matching parens
set history=200

syntax enable " highlighting

"alias uppercase commands
:command W w
:command Wq wq

" make Y behave like D and C
nnoremap Y y$

" make search show context
nnoremap n nzz
nnoremap N Nzz

" indentation
set autoindent
set smartindent
set copyindent
set preserveindent

" turn it off for pasting
set pastetoggle=<F2>

" spellcheck
" in normal mode, F5 will toggle spelling highlight
:nnoremap <F5> :setlocal spell!<CR>

" tabs
"set exrc " allow per project overrides
set noexpandtab
set tabstop=3
set shiftwidth=3

" don't resize all windows when one close
set noequalalways

" search
set nohlsearch " no highlight
set incsearch " incremental
set ignorecase " case insensitve search
set smartcase " upper case search only matches uppercase

