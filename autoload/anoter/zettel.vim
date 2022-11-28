" I follow a ""zettelkasten"" methodology for my note taking
" It isn't zettelkasten *per se* (not by a long shot), but it is good enough
" for me to focus on my notes and the content in them
function! anoter#zettel#new()
    let note_title = input('[new zettel]: ')
    if empty(note_title)
        echomsg "[error] no zettel title provided, aborting."
        return
    endif
    redraw
    let fullpath = g:zettel_dir . strftime('%Y%m%d%H%M%S') . '-' . substitute(note_title, ' ', '-', 'g') . '.md'
    call writefile(['# ' . note_title, '> created: ' . strftime(g:anoter_strftime), '> tags: '], fullpath, 'a')
    echomsg "[zettel] new note \"" . note_title . "\" created."
    execute "edit " . fullpath
endfunction

function! anoter#zettel#find()
    " not implemented
endfunction

function! anoter#zettel#findTags()
    " not implemented
endfunction

