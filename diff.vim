" expand tabs in diffs
setlocal expandtab

" grab two lines from next section into current section
let @q="}j2ddj{{jp"
" expand a 'same' diff line into 'add' and 'subtract' lines
let @w="yypk0r+jr-"
let @e="a!f=2dw"

" find first difference
function! DiffColDiff(line1, line2)
	let l:common_len = 0
	for i in range(1, strlen(a:line1)-1)
		if a:line1[i] != a:line2[i]
			break
		endif
		let l:common_len += 1
	endfor

	" check for one line shorter
	if strlen(a:line1) > strlen(a:line2)
		if l:common_len < strlen(a:line2)
			return l:common_len + 1
		endif
		return strlen(a:line2)
	endif

	 if strlen(a:line1) < strlen(a:line2)
		if l:common_len < strlen(a:line1)
			return l:common_len + 1
		endif
		return strlen(a:line1)
	endif

	" compared all chars
	if l:common_len == strlen(a:line2)-1
		return 0
	endif

	return l:common_len + 1
endfunction

function! VimCollapseDiff()
	" pull line under cursor
	let l:cur_line = getline('.')

	" if not a diff line
	if l:cur_line[0] == " "
		" delete it
		execute "normal! dd"
		" done
		return
	endif

	" pull next line
	let l:nxt_line = getline(line('.') + 1)

	" if two @ markers in a row, delete the upper one
	if l:cur_line[0] == '@' && l:nxt_line[0] == '@'
		execute "normal! dd"
		return
	endif

	if l:cur_line[0] != '-' && l:cur_line[0] != '+'
		return
	endif

	" make sure lines alternate + and -
	if l:cur_line[0] == '-' && l:nxt_line[0] != '+'
		return
	endif
	if l:cur_line[0] == '+' && l:nxt_line[0] != '-'
		return
	endif

	" find first difference
	let l:col_diff = DiffColDiff(l:cur_line, l:nxt_line)

	if l:col_diff != 0
		" move cursor to the diff
		execute "normal! " . (l:col_diff+1) . "|"
	else
		" merge the - and + lines to a no-diff
		execute "normal! dd"
		execute "normal! 0|"
		execute "normal! r "
	endif
endfunction

" keep Tcl version for now
"nmap <C-d> :call VimCollapseDiff()<CR>
nmap <C-d> :tcl collapseDiff<CR>

