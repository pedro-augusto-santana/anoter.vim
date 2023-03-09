" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

if exists("g:anoter_init")
    finish
endif

let g:anoter_init = v:true
call anoter#init()
