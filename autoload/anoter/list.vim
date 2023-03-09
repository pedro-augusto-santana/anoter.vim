" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

" being very generous allowing more than one space
const s:match_list_item     = '\v(^(\s+)?(\*|\-|\+|\d+.)\s+)'
const s:task_states = g:anoter_task_states.pending + g:anoter_task_states.done

function! anoter#list#toggle()
    const line  = getline('.')
    const start = matchend(line, s:match_list_item)
    if start >= 0
        " inside code blocks, no action is performed
        " NOTE this does *NOT* work with treesitter
        " (maybe find another method later)
        if anoter#utils#matches('markdownCode*') | return | endif
        const state = matchstr(line, '\v^\w+', start)
        const pos = index(s:task_states, state)
        if pos < 0 | return | endif
        call anoter#list#changeState(state, pos)
        return
    endif
endfunction

function! anoter#list#changeState(state, position)
    const nline = substitute(getline('.'), a:state, s:task_states[(a:position + 1) % len(s:task_states)], '')
    call setline('.', nline)
    call anoter#list#doneLine(a:state, a:position) " handles the completed line below task
endfunction

function! anoter#list#doneLine(state, position)
    const next = s:task_states[(a:position + 1) % len(s:task_states)]

    const has_done_lbl = getline(line('.') + 1) =~ '\v^\>\s+' . g:anoter_done_label . '.*'
    if has_done_lbl
        call deletebufline('%', line('.') + 1, line('.') + 1)
    endif

    if index(g:anoter_task_states.done, next) >= 0
        call append(line('.'), '> ' . g:anoter_done_label . ' ' . strftime(g:anoter_done_strftime))
    endif
endfunction

function! anoter#list#wontDo(state, position)
    const next = g:anoter_task_states.failed[(a:position + 1) % len(g:anoter_task_states.failed)]
    const has_done_lbl = getline(line('.') + 1) =~ '\v^\>\s+' . g:anoter_done_label . '.*'
    if has_done_lbl
        call deletebufline('%', line('.') + 1, line('.') + 1)
    endif

    if index(g:anoter_task_states.failed, next) >= 0
        call append(line('.'), '> ' . g:anoter_done_label . ' ' . strftime(g:anoter_done_strftime))
    endif
endfunction
