" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

" being very generous allowing more than one space
const s:match_list_item     = '\v(^(\s+)?(\*|\-|\+|\d+.)\s+)'
const s:task_states = g:anoter_task_states.pending + g:anoter_task_states.done
const s:failed_states = g:anoter_task_states.failed

function! anoter#list#toggle()
    const line  = getline('.')
    const start = matchend(line, s:match_list_item)
    if start < 0 | return | endif

    " inside code blocks, no action is performed
    " NOTE this does *NOT* work with treesitter
    if anoter#utils#matches('markdownCode*') | return | endif


    const state = matchstr(line, '\v^\w+', start)
    const pos = index(s:failed_states + s:task_states, state)

    if pos < len(s:failed_states)
        " if it's a failed state, go back to first task state by default
        " when toggling through states
        " (not the best solution but works, for now)
        call anoter#list#changeState(state, s:task_states[0])
        return
    endif

    call anoter#list#changeState(state, s:task_states[(pos + 1) % len(s:task_states)])
endfunction

function! anoter#list#changeState(state, next)
    const nline = substitute(getline('.'), a:state, a:next, '')
    call setline('.', nline)
    call anoter#list#doneLine(a:state, a:next) " handles the completed line below task
endfunction

function! anoter#list#doneLine(state, next)
    const has_done_lbl = getline(line('.') + 1) =~ '\v^\>\s+' . g:anoter_done_label . '.*'
    if has_done_lbl
        call deletebufline('%', line('.') + 1, line('.') + 1)
    endif

    if index(g:anoter_task_states.done + s:failed_states, a:next) >= 0
        call append(line('.'), '> ' . g:anoter_done_label . ' ' . strftime(g:anoter_done_strftime))
    endif
endfunction

function! anoter#list#wontDo()
    " NOTE (maybe) abstract this block to function later?
    const line  = getline('.')
    const start = matchend(line, s:match_list_item)
    if start < 0 | return | endif

    if anoter#utils#matches('markdownCode*') | return | endif
    const state = matchstr(line, '\v^\w+', start)
    const pos = index(s:failed_states, state)
    if pos < 0 " if not a failed state, default to first on the array
        call anoter#list#changeState(state, s:failed_states[0])
        return
    endif

    " otherwise, cycle through failed states
    call anoter#list#changeState(state, s:failed_states[(pos + 1) % len(s:failed_states)])
endfunction
