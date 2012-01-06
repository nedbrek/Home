" expand tabs in diffs
set expandtab

" grab two lines from next section into current section
let @q="}j2ddj{{jp"
" expand a 'same' diff line into 'add' and 'subtract' lines
let @w="yypk0r+jr-"
let @e="a!f=2dw"

nmap  :tcl collapseDiff<CR>

