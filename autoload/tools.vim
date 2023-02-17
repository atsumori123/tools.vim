"*******************************************************
"* Function name: tools_disp_menu()
"* Function		: Make popup menu
"*
"* Argument		: menu : ID of display menu
"*******************************************************
function s:tools_disp_menu(menu)

	let s:ToolsMenu = []
	if a:menu == 'M'
		" Control code
		let temp = &list == 0 ? "UnDisplay" : "Display"
		call add(s:ToolsMenu, " Control code        : ".temp)

		" Tabstop
		call add(s:ToolsMenu, " Tabstop(toggle 4,8) : ".&tabstop)

		" modifiable
		let temp = &modifiable ? "modifiable" : "nomodifiable"
		call add(s:ToolsMenu, " Modifiable          : ".temp)

		" R/W
		let temp = &readonly ? "Read Only" : "Write Allow"
		call add(s:ToolsMenu, " R/W                 : ".temp)

		" Search-case
		let temp = &ignorecase ? "Insensitive" : "Sensitive"
		call add(s:ToolsMenu, " Search case         : ".temp)

		" reset errorformat
		call add(s:ToolsMenu, " Reset errorformat")

		" Change current path
		let temp = execute("pwd")
		let temp = strpart(temp, 1, strlen(temp)-1)
		call add(s:ToolsMenu, " Set current dir     : ".temp)

		" Get Current file path
		let temp = expand("%:p")
		call add(s:ToolsMenu, " Get file path       : ".temp)

	elseif a:menu == 'ToolsConvert'
	endif

	const winid = popup_create(s:ToolsMenu, {
			\ 'border': [1,1,1,1],
			\ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
			\ 'cursorline': 1,
			\ 'wrap': v:false,
			\ 'mapping': v:false,
			\ 'title': ' Tools ',
			\ 'callback': "s:tools_menu_selected_handler",
			\ 'filter': 'Tools_menu_filter',
			\ 'filtermode': 'n'
			\ })
	call popup_filter_menu(winid,'k')
endfunction
"
"*******************************************************
"* Function name: Tools_menu_filter()
"* Function		: Filtering when popup-menu is selected
"*
"* Argument		: winid : Winddow ID
"*				  key   : Pressed key
"*******************************************************
function! Tools_menu_filter(winid, key) abort

"	if a:key == 'l'
		" ---------------------------------
		"  when pressed 'l'(next) key
		" ---------------------------------
"		call win_execute(a:winid, 'let w:lnum = line(".")')
"		let l:index = getwinvar(a:winid, 'lnum', 0)
"		call popup_close(a:winid, l:index)
"		return 1

"	elseif a:key == 'h'
		" ---------------------------------
		"  when pressed 'h'(back) key
		" ---------------------------------
"		let l:index = 98
"		call popup_close(a:winid, l:index)
"		return 1

	if a:key == 'q'
		" ---------------------------------
		"  when pressed 'q'(Terminate) key
		" ---------------------------------
		let l:index = 99
		call popup_close(a:winid, l:index)
		return 1
	endif

	" --------------------------------
	"  Other, pass to normal filter
	" --------------------------------
	return popup_filter_menu(a:winid, a:key)
endfunction

"*******************************************************
"* Function name: s:tools_menu_selected_handler()
"* Function		: Handler processing when selected of tools menu
"*
"* Argument		: winid : Winddow ID
"*				  result: Number of selected item
"*******************************************************
function! s:tools_menu_selected_handler(winid, result) abort

	if a:result == 1
		" Control-code (Display / Undisplay)
		execute &list ? 'set nolist' : 'set list'

	elseif a:result == 2
		" Tabstop
		if &tabstop == 4
			execute 'set tabstop=8'
			execute 'set shiftwidth=8'
		else
			execute 'set tabstop=4'
			execute 'set shiftwidth=4'
		endif

	elseif a:result == 3
		" modifiable / nomodifiable
		execute &modifiable ? 'set nomodifiable' : 'set modifiable'

	elseif a:result == 4
		" R/W (ReadOnly / WriteAllow)
		execute &readonly ? 'set noro' : 'set ro'

	elseif a:result == 5
		" Search-case (noignorecase / ignorecase)
		execute &ignorecase ? 'set noignorecase' : 'set ignorecase'

	elseif a:result == 6
		" reset errorformat
		if &buftype != 'quickfix'
			echohl WarningMsg | echomsg 'This buffer type is not quickfix' | echohl None
			return
		endif
		execute 'set errorformat=%f\|%l\|\ %m'
		silent cgetbuffer
		set modifiable

	elseif a:result == 7
		let dir = input('Set current directory: ', expand("%:h"), 'dir')
		execute 'cd '.dir

	elseif a:result == 8
		let @* = expand("%:p")
	endif

endfunction

"------------------------------------------------------
" tools#start()
"------------------------------------------------------
function tools#start()
	call s:tools_disp_menu("M")
endfunction


