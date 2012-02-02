" leave tabs in Tcl files
setlocal noexpandtab

" smartindent thinks # is for #ifdef
" but it is a comment in Tcl
" the official fix is to remap # to X<backspace>#, which tricks the indenter
inoremap # X<BS>#

