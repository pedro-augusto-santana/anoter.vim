let s:TODOStates = g:anoter_todo_states + g:anoter_done_states
" any number of spaces (including none) followed by '*', '+', '-' and any
" group of characters (rest of the line)
let s:list_item_pattern = '\v^((\s+)?(\*|\+|-|\d+\.)(\s+)).*'
" these match any list followed by [ ] or [x], and also match [~] (WONTDO)
" checklist items
let s:checklist_unchecked = '\v^((\s+)?(\*|\+|-|\d+\.)(\s)(\[\s+\]|\[\~\]))'
let s:checklist_checked = '\v^((\s+)?(\*|\+|-|\d+\.)(\s)(\[x\]|\[\~\]))'

function! anoter#list#toggleTODO()
    let line = matchstr(getline('.'), s:list_item_pattern)
    if empty(line) | return | endif

    let line_state = matchstr(line, '\v(' . join(g:anoter_workflow_states, '|') . ')')
    if index(g:anoter_workflow_states, line_state) >= 0
        " this can look like it is a little esoteric, but other than the crooked
        " syntax it is pretty straight forward.
        " basically it is a normalized cycle, the first position points to the
        " second, and so on, until the last position points to the first one
        " again, closing the workflow loop.
        call anoter#list#setTODOState(line_state,
                    \s:TODOStates[(index(s:TODOStates, line_state) + 1) % len(s:TODOStates)])
        " index of not found returns -1, so the next state is always the first
        " state of the "TODOState" array, restarting the normal cycle
    else " for checklists [ ] -> [x]
        if match(line, s:checklist_checked) >= 0
            call setline('.', substitute(getline('.'), '\[x\]\|\[\~\]', '\[ \]' , '')) | return
        elseif match(line, s:checklist_unchecked) >= 0
            call setline('.', substitute(getline('.'), '\[ \+\]\|\[\~\]', '\[x\]', '')) | return
        endif
    endif
endfunction

function! anoter#list#WONTDO()
    " TODO move this to docs
    " the fail states defined in g:anoter_fail_states are outside the normal
    " cycling of states, generally failed states are to be an exception and as
    " such have a diferent keybinding, but can be toggled back to normal
    " TODOState with <C-Space> keybinding
    let line = matchstr(getline('.'), s:list_item_pattern)
    if empty(line) | return | endif
    let line_state = matchstr(line, '\v(' . join(g:anoter_workflow_states, '|') . ')')
    if (index(g:anoter_workflow_states, line_state)) >= 0
        call anoter#list#setTODOState(line_state,
                    \ g:anoter_fail_states[
                    \ (index(g:anoter_fail_states, line_state) + 1)
                    \ % len(g:anoter_fail_states)])
        return
    elseif match(line, s:checklist_checked) >= 0 || match(line, s:checklist_unchecked) >= 0
        call setline('.', substitute(getline('.'), '\[ \+\]\|\[x\]', '\[~\]', '')) | return
    endif
endfunction

function! anoter#list#setTODOState(current, new)
    call setline('.', substitute(getline('.'), a:current, a:new, ''))
    if !g:anoter_log_timer | return | endif
    let closing_pattern = '\v^(\s+)?`Closed:(\s+)?.*`$' " `Closed: g:anoter_strftime`
    if index(g:anoter_done_states + g:anoter_fail_states, a:new) >= 0
        " if line matches closing pattern, only replace the line with the new
        " content
        if match(getline(line('.') + 1), closing_pattern) == 0
            call setline(line('.') + 1, '`Closed: ' . strftime(g:anoter_strftime) . '`')
            " workaround for reindenting items inside nested lists
            execute 'normal! j==k'
        else " if not append new line
            " NOTE this ↓ does not work with visual selecions
            execute 'normal! o'. '`Closed: ' . strftime(g:anoter_strftime) . '`'
            execute 'normal! k'
        endif
        return
    elseif index(g:anoter_todo_states, a:new) >= 0
        " if matches pattern, delete when flipping through states
        if match(getline(line('.') + 1), closing_pattern) == 0
            " why there is no delete() function is beyond me
            execute line('.') + 1 'delete _'
            " moves cursor up one line
            execute 'normal! k'
        endif
        return
    endif
endfunction

