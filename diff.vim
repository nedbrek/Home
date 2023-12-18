" expand tabs in diffs
setlocal expandtab

" grab two lines from next section into current section
let @q="}j2ddj{{jp"
" expand a 'same' diff line into 'add' and 'subtract' lines
let @w="yypk0r+jr-"
let @e="a!f=2dw"

function! DiffColDiff(line1, line2)
	" find first difference
	let l:common_len = 0
	for i in range(1, strlen(a:line1)-1)
		if a:line1[i] != a:line2[i]
			break
		endif
		let l:common_len += 1
	endfor
	if l:common_len == strlen(a:line2)-1
		return 0
	endif
	return l:common_len + 1
endfunction

function! VimCollapseDiff()
	let l:cur_line = getline('.')
	let l:nxt_line = getline(line('.') + 1)
	let l:col_diff = DiffColDiff(l:cur_line, l:nxt_line)
	if l:col_diff != 0
		execute "normal! " . (l:col_diff+1) . "|"
	else
		execute "normal! dd"
		execute "normal! 0|"
		execute "normal! r "
	endif
endfunction

nmap <C-d> :tcl collapseDiff<CR>

