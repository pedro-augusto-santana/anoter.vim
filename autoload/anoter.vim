" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

function! anoter#init()
    if !exists("g:anoter_home")
        let g:anoter_home = fnamemodify("~", ":p") . "notes/"
    endif

    if !exists("g:anoter_task_states")
        " follows a (kind of) org-mode philosophy, so that
        " the states are cycleable and can be added or removed
        " at will
        " failed states are it's own cycle, isolated from pending-finished
        let g:anoter_task_states = {
                    \ "pending": ['TODO', 'PREPARING', 'DOING'],
                    \ "done": ['DONE'],
                    \ "failed": ['WONTDO', 'CANCELED']
                    \ }
    endif

    if !exists("g:anoter_done_label")
        let g:anoter_done_label = "Done"
    endif

    if !exists("g:anoter_done_strftime")
        let g:anoter_done_strftime = "%d %b %Y | %H:%M"
    endif

endfunction

function! anoter#index()
    let rootExists = anoter#checkRootDir()
    if !rootExists | return | endif
    execute "edit " . resolve(g:anoter_home . "index.md")
endfunction

function! anoter#checkRootDir()
    if isdirectory(g:anoter_home) | return v:true | endif
    let createdir = input("[anoter] notes directory not found, create? (y/n): ", "y")
    redraw
    if (createdir =~? "y")
        call mkdir(g:anoter_home, "p")
        echomsg "[anoter] created notes directory at: " . g:anoter_home
        return v:true
    else
        echomsg "[anoter] aborted directory creation."
        return v:false
    endif
endfunction

" plugin keymappings
nnoremap <silent><leader>ni :call anoter#index()<CR>
nnoremap <silent><leader>tni :tabnew \| :call anoter#index()<CR>
