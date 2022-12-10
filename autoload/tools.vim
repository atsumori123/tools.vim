
let s:save_cpo = &cpoptions
set cpoptions&vim

"-------------------------------------------------------
" s:tools_proc()
"-------------------------------------------------------
function! s:tools_proc(result) abort
	if a:result == 1
		" Control-code (Display / Undisplay)
		close
		execute &list ? 'set nolist' : 'set list'

	elseif a:result == 2
		" Tabstop
		close
		if &tabstop == 4
			execute 'set tabstop=8'
			execute 'set shiftwidth=8'
		else
			execute 'set tabstop=4'
			execute 'set shiftwidth=4'
		endif

	elseif a:result == 3
		" modifiable / nomodifiable
		close
		execute &modifiable ? 'set nomodifiable' : 'set modifiable'

	elseif a:result == 4
		" R/W (ReadOnly / WriteAllow)
		close
		execute &readonly ? 'set noro' : 'set ro'

	elseif a:result == 5
		" Search-case (noignorecase / ignorecase)
		close
		execute &ignorecase ? 'set noignorecase' : 'set ignorecase'

	elseif a:result == 6
		close
		let dir = input('Set current directory: ', expand("%:h"), 'dir')
		execute 'cd '.dir

	elseif a:result == 7
		close
		let @* = expand("%:p")
	endif
endfunction

"-------------------------------------------------------
" s:selected_handler()
"-------------------------------------------------------
function! s:selected_handler() abort
	if empty(s:selected_handler)
		return
	endif

	let s:func = function(s:selected_handler)
	call s:func(line("."))
endfunction

"-------------------------------------------------------
" s:make_menu()
"-------------------------------------------------------
function s:make_menu(menu) abort

	let menu = []
	if a:menu == 'M'
		" Control code
		let temp = &list == 0 ? "UnDisplay" : "Display"
		call add(menu, " Control code        : ".temp)

		" Tabstop
		call add(menu, " Tabstop(toggle 4,8) : ".&tabstop)
		"
		" modifiable
		let temp = &modifiable == 0 ? "nomodifiable" : "modifiable"
		call add(menu, " modifiable          : ".temp)

		" R/W
		let temp = &readonly == 0 ? "Write Allow" : "Read Only"
		call add(menu, " R/W                 : ".temp)

		" Search-case
		let temp = &ignorecase == 0 ? "Sensitive" : "Insensitive"
		call add(menu, " Search case         : ".temp)

		" Change current path
		let temp = execute("pwd")
		let temp = strpart(temp, 1, strlen(temp)-1)
		call add(menu, " Set current dir     : ".temp)

		" Get Current file path
		let temp = expand("%:p")
		call add(menu, " Get file path       : ".temp)

		let s:selected_handler = 's:tools_proc'
	endif

	return menu
endfunction

"-------------------------------------------------------
" s:open_floating_window()
"-------------------------------------------------------
function! s:open_floating_window(menu) abort
	let menu = s:make_menu(a:menu)

	let winnum = bufwinnr('-tools-')
	if winnum != -1
		" Already in the window, jump to it
		exe winnum.'wincmd w'
		return
	else
		" open floating window
		let win_id = nvim_open_win(bufnr('%'), v:true, {
			\   'width': 60,
			\   'height': len(menu),
			\   'relative': 'cursor',
			\   'anchor': "NW",
			\   'row': 1,
			\   'col': 0,
			\   'external': v:false,
			\})

		" draw to new buffer
		enew
		file `= '-tools-'`
	endif

	setlocal modifiable

	call setline('.', menu)
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal noswapfile
	setlocal nowrap
	setlocal nonumber

	nnoremap <buffer> <silent> <CR> :call <SID>selected_handler()<CR>
	nnoremap <buffer> <silent> q :close<CR>

	execute 'syntax match gr "^.*\: "'
	highlight link gr Directory
	highlight MyNormal guibg=#404040
	setlocal winhighlight=Normal:MyNormal

	setlocal nomodifiable
endfunction

"-------------------------------------------------------
" s:start()
"-------------------------------------------------------
function! tools#start() abort
	call s:open_floating_window("M")
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
