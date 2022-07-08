let s:save_cpo = &cpoptions
set cpoptions&vim

command! -nargs=0 Tools call tools#start()

let &cpoptions = s:save_cpo
unlet s:save_cpo
