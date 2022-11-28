" TODO: write documentation
if exists("g:anoter_init") " if plugin already initialized, ignore initialization
    finish
endif
let g:anoter_init = v:true
call anoter#init()
