" anoter - simple vimscript notetaking plugin
" Author: Pedro Augusto Santana
" License: MIT
" function to initialize the plugin and all configurations
function! anoter#init()
    if !exists('g:notes_dir')
        let g:notes_dir = expand('~/notes/')
        let g:zettel_dir = g:notes_dir . 'zettel/'
    endif

    " https://orgmode.org/guide/Multi_002dstate-Workflow.html
    " something similar to what orgmode has implemented, in other words, I
    " absolutely shamelessly copied it from orgmode.
    if !exists('g:anoter_todo_states')
        let g:anoter_todo_states = ['TODO', 'PREPARE', 'DOING']
    endif
    if !exists('g:anoter_done_states')
        let g:anoter_done_states = ['DONE', 'ENDED']
    endif
    if !exists('g:anoter_fail_states')
        let g:anoter_fail_states = ['WONTDO', 'CANCELLED']
    endif

    let g:anoter_workflow_states = g:anoter_todo_states + g:anoter_done_states + g:anoter_fail_states

    if !exists('g:anoter_log_timer')
        let g:anoter_log_timer = v:true
    endif

    if !exists('g:anoter_strftime')
        let g:anoter_strftime = '%d/%m/%Y : %Hh%M' " default completion timestamp
    endif

    if !exists('g:anoter_schedule')
        let g:anoter_schedule = ['DUE', 'AT', 'SCHEDULED']
    endif
endfunction

" global keymappings
nnoremap <silent> <leader>nz :call anoter#zettel#new()<CR>
nnoremap <silent> <leader>ni :call anoter#notes#index() <CR>
