" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

syn match anoterTagItem "\v(\s+|^)\@.*(\s+|$)"
syn region markdownQuote start=/\v^(\s+)?\>/ end=/\v$/

hi link anoterTagItem Comment
hi link markdownQuote Comment

const s:list_regex = '^(\+|\*|(\d+\.)|-)(:)?\s+'

exe 'syn match anoterTodoItem /\v' . s:list_regex . '(' . join(g:anoter_task_states.pending, '|') . ')(\s+|:)/'
exe 'syn match anoterDoneItem /\v' . s:list_regex . '(' . join(g:anoter_task_states.done, '|') . ')(\s+|:)/'
exe 'syn match anoterFailItem /\v' . s:list_regex . '(' . join(g:anoter_task_states.failed, '|') . ')(\s+|:)/'

hi link anoterTodoItem Purple
hi link anoterDoneItem Green
hi link anoterFailItem Red
