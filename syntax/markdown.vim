" color codes from gruvbox-material with original pallete (maybe remove it later)
" highlight TodoItems     ctermfg=175 guifg=#d3869b
" highlight FailStates    ctermfg=167 guifg=#fb4934
" highlight DoneStates    ctermfg=142 guifg=#b8bb26
highlight link ScheduleItems Comment
highlight link FailStates Exception
highlight link TodoItems MarkdownRule
highlight link DoneStates GreenSign
" TODO use default 'gui-colors' for each parameter
call matchadd('TodoItems',      '\(*\|+\|-\|\d\+.\) \(' . join(g:anoter_todo_states, '\|') .'\):\?')
call matchadd('FailStates',     '\(*\|+\|-\|\d\+.\) \(' . join(g:anoter_fail_states, '\|') .'\):\?')
call matchadd('DoneStates',     '\(*\|+\|-\|\d\+.\) \(' . join(g:anoter_done_states, '\|') .'\):\?')
call matchadd('ScheduleItems',  '\(*\|+\|-\|\d\+.\) \(' . join(g:anoter_schedule, '\|') .'\):\?.*')

" highlight group based on:
" https://www.reddit.com/r/vim/comments/g631im/any_way_to_enable_true_markdown_strikethrough/
" TODO fix it (not delimited like bold or italic, syntax is leaking through)
highlight markdownStrikethrough gui=strikethrough
call matchadd('markdownStrikethrough', '\~\~\zs.\{-}\ze\~\~')
call matchadd('Conceal',  '\~\~\ze.\{-}\~\~', 10, -1, {'conceal':''})
call matchadd('Conceal',  '\~\~.\{-}\zs\~\~\ze', 10, -1, {'conceal':''})

" makes the markdown quote syntax '> TEXT' look like an actual quote, looking
" commented
highlight link markdownQuote Comment
call matchadd('markdownQuote', '\v^(\s+)?\>.*$')

