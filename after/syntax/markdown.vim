" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

syn region anoterTagItem start=/\v\@/ end=/\v(\s+|$)/
syn region markdownQuote start=/\v^(\s+)?\>/ end=/\v$/

hi link anoterTagItem Comment
hi link markdownQuote Comment


" TODO find a nicer way to deal with the list item regex
exe 'syn match anoterTodoItem /\v^(\+|\*|(\d+\.)|-)(:)?\s+(' . join(g:anoter_task_states.pending, '|') . ')/'
exe 'syn match anoterDoneItem /\v^(\+|\*|(\d+\.)|-)(:)?\s+(' . join(g:anoter_task_states.done, '|') . ')/'
exe 'syn match anoterFailItem /\v^(\+|\*|(\d+\.)|-)(:)?\s+(' . join(g:anoter_task_states.failed, '|') . ')/'

hi link anoterTodoItem Purple
hi link anoterDoneItem Green
hi link anoterFailItem Red
