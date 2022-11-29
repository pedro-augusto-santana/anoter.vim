" TODO add handling for image links: ![Descriptor](Image Link)
let s:link_pattern = '\v(\[.{-}\]\(.{-}\))|(\[.{-}\]\[(\d+)?\])|(\[((\d+)|(.{-}))\]\:(\s+)?(\<.{-}\>|\S*)|\<.{-}\>)'
function! anoter#link#follow()
    let link = anoter#link#match()
    if empty(link) | return | endif
    let descriptor_pattern = '\v\[.{-}\]'
    let url_pattern = '\v(\[(\d+)?\])|(\(.{-}\))|\<.{-}\>'
    let descriptor = matchstr(link, descriptor_pattern)
    " the url/reference part always start after the descriptor match ended"
    let url = matchstr(link, url_pattern, matchend(link, descriptor_pattern))
    if url =~ '\v\[(\d+)\]' " match self-referenced/numbered reference links
        call searchpos('\v\[' . matchstr(url, '\v\d+') . '\]:.*', 's') " match link number
        return
    elseif (url =~ '\v\[(\s+)?\]')
        call searchpos('\v['. descriptor[1:-1] . ']:.*', 's') " match the descriptor of the link
        return
    else " everything else is a normal link, and will be followed as such
        " FIXME the "[descriptor]: url" format is not working right now, the url
        " needs to be wrapped in '<>' to work properly
        " FIXME url keeps getting matched with trailing ')'
        " for now using anoter#utils#strip to remove it
        let url = anoter#utils#strip(url)[1:-2] " trimming spaces and delimiters
        if empty(url) | return | endif
        if netrw#CheckIfRemote(url)
            " I didn't want to depend on other plugins
            " but is netrw so whatever
            call netrw#BrowseX(url, netrw#CheckIfRemote())
            return
        else
            " this is a very naive implementation, and allows for lazy
            " matching, but it's good enough, at least for now.
            let url = split(url, '\v(#+)')
            let editcommand = 'edit ' . anoter#utils#abspath(url[0])
            execute editcommand
            if (len(url) == 2) " only if contains 2 parts multiple ids are ignored
                call search('\v^(\s+)?(#+)(\s+)' . url[1])
            endif
        endif
    endif
endfunction

" this function was loosely based on vimwiki#base#matchstr_at_cursor from
" the (excellent) vimwiki plugin
function! anoter#link#match()
    " BUG the matching returns nothing when in the closing delimiter of the
    " url part of a markdown link. need to fix
    let col = col('.')
    let line = getline('.')
    let links = []
    let lmatch = match(line, s:link_pattern, 0) " search for links on the current line
    if (lmatch < 0) | return | endif
    let lend = matchend(line, s:link_pattern, lmatch) " find end of first matched link
    call add(links, [lmatch, lend]) " adds it to the current line link list"
    " admittedly this seems a little bit hacky, mostly because it is
    while (lmatch >= 0) " while there are links on the line, index them
        let lmatch = match(line, s:link_pattern, lend)
        if lmatch < 0 | break | endif
        let lend = matchend(line, s:link_pattern, lmatch)
        call add(links, [lmatch, lend])
    endwhile

    for pos in links
        if (pos[0] < col && col < pos[1]) " unfortunately vimscript doesn't have "a < b < c" syntax
            return line[pos[0]:pos[1]] " return the correct link
        endif
    endfor
    return '' " if not inside the correct position, return nothing
endfunction

function! anoter#link#findNext()
    call search(s:link_pattern, 'pszw')
endfunction

function! anoter#link#findPrev()
    call search(s:link_pattern, 'bpszw')
endfunction
