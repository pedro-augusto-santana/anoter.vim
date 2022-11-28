function! anoter#utils#strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! anoter#utils#abspath(filespec)
    " function extracted from https://stackoverflow.com/a/22860907/11512974
    " with some (very) minor alterations
    if expand('%:h') !=# '.'
        let l:save_cwd = getcwd()
        let l:chdirCommand = (haslocaldir() ? 'lchdir!' : 'chdir!')
        execute l:chdirCommand '%:p:h'
    endif
    try
        " Get the full path to a:filespec, relative to the current file's directory.
        let l:absoluteFilespec = fnamemodify(a:filespec, ':p')
    finally
        if exists('l:save_cwd')
            execute l:chdirCommand fnameescape(l:save_cwd)
        endif
    endtry
    return l:absoluteFilespec
endfunction

