" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

syn match anoterTagItem "\v(\s+|^)\@.*(\s+|$)"
syn region markdownQuote start=/\v^(\s+)?\>/ end=/\v$/

hi link anoterTagItem Comment
hi link markdownQuote Comment


" TODO find a nicer way to deal with the list item regex
exe 'syn match anoterTodoItem /\v^(\+|\*|(\d+\.)|-)(:)?\s+(' . join(g:anoter_task_states.pending, '|') . ')(\s+|:)/'
exe 'syn match anoterDoneItem /\v^(\+|\*|(\d+\.)|-)(:)?\s+(' . join(g:anoter_task_states.done, '|') . ')(\s+|:)/'
exe 'syn match anoterFailItem /\v^(\+|\*|(\d+\.)|-)(:)?\s+(' . join(g:anoter_task_states.failed, '|') . ')(\s+|:)/'

hi link anoterTodoItem Purple
hi link anoterDoneItem Green
hi link anoterFailItem Red
