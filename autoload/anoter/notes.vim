function! anoter#notes#index()
    call chdir(g:notes_dir)
    execute "edit " . resolve(expand(g:notes_dir) . 'index.md')
endfunction
