" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

" TODO add support for reference style links
const s:mdLinkPattern   = '\v`@!(!?\[.{-}\](\(.{-}\)|\[\d+\])|\<.{-}\>)`@!'
const s:urlPattern      = '\v\(.{-}\)|\<.{-}\>'
const s:externalLinkPattern = '\v'

" NOTE maybe change this to global configuration? that way whoever uses it can
" set it to their use case.
const s:extFileList = ['mp3', 'mp4', 'jpeg', 'png', 'docx',
            \ 'xlsx', 'xls', 'pdf', 'pptx', 'ppt', 'jpg',
            \ 'tiff', 'tif', 'mkv', 'webp', 'epub']

function! anoter#link#follow()
    const link = anoter#link#getUnderCursor()
    if empty(link) || anoter#utils#matches('markdownCode*') | return | endif

    const url = matchstr(link, s:urlPattern)[1:-2] " strip brackets/parenthesis
    if empty(url) | return | endif

    const matched = anoter#utils#isExternalLink(url)
    if empty(matched)
        const ext = fnamemodify(url, ':e')
        if index(s:extFileList, ext) > 0
            " if the file extension matches any of the external links
            " extensions, open it with system tool.
            call anoter#utils#sysOpen(anoter#utils#abspath(url))
            return
        endif
        " handles direct reference to a heading
        const ref = split(url, '\v(#+)')
        execute "edit " . anoter#utils#abspath(ref[0])
        if len(ref) > 1
            call search('\v# ' . ref[1], '')
        endif
        return
    else
        call anoter#utils#sysOpen(anoter#utils#abspath(matched))
        return
    endif
endfunction

function! anoter#link#getUnderCursor()
    let links   = []
    const line  = getline('.')
    const col   = col('.')

    let start = match(line, s:mdLinkPattern, 0)
    while start >= 0
        let end = matchend(line, s:mdLinkPattern, start)
        call add(links, [start + 1, end])
        let start = match(line, s:mdLinkPattern, end)
    endwhile
    const curr = filter(links, { idx, val -> val[0] <= col && val[1] >= col })
    if empty(curr) | return | endif
    return strpart(line, curr[0][0] - 1, curr[0][1] - curr[0][0] + 1) " start - 1, length + 1
endfunction

function! anoter#link#findNext()
    call search(s:mdLinkPattern,'spz')
endfunction

function! anoter#link#findPrev()
    call search(s:mdLinkPattern, 'b')
endfunction
