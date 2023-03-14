" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

function! anoter#utils#matchHL()
    " adapted from: https://stackoverflow.com/a/37040415/11512974
    let syntaxID = synID(line('.'), col('.'), 1)
    return {'name': synIDattr(syntaxID, 'name'), 'linked': synIDattr(synIDtrans(syntaxID), 'name')}
endfunction

function! anoter#utils#matches(exp)
    const syn = anoter#utils#matchHL()
    return syn.name =~ a:exp
endfunction

function! anoter#utils#isExternalLink(link)
    const l:linkExpr = '\v((http(s?)|file):\/\/(www\.)?)([a-zA-Z0-9@:%\-_\/\+~#=]*)(\.|\/)([a-zA-Z0-9@:\?%\-_\+~#=\/\.]*)'
    return matchstr(a:link, l:linkExpr)
endfunction

function! anoter#utils#sysOpen(link)
    " TODO add better error handling
    " this is too simplistic
    silent exec '!open ' . a:link
endfunction

function! anoter#utils#abspath(filespec)
    " function extracted from https://stackoverflow.com/a/22860907/11512974
    " with some (very) minor alterations

    " this matching doesn't sit well with me at least find another of
    " matching way later
    let l:parsedfspec = substitute(a:filespec, '^.*\$ROOT\/', g:anoter_home, '')

    if expand('%:h') !=# '.'
        let l:save_cwd = getcwd()
        let l:chdirCommand = (haslocaldir() ? 'lchdir!' : 'chdir!')
        execute l:chdirCommand '%:p:h'
    endif
    try
        " Get the full path to a:filespec, relative to the current file's directory.
        let l:absoluteFilespec = fnamemodify(l:parsedfspec, ':p')
    finally
        if exists('l:save_cwd')
            execute l:chdirCommand fnameescape(l:save_cwd)
        endif
    endtry
    return l:absoluteFilespec
endfunction
