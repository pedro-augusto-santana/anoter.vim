" TODO implement syntax folding (reference) https://www.sitebase.be/simple-vim-note-taking-in-markdown/
" markdown exclusive keybidings
" task list management
nnoremap <silent> <C-Space> :call anoter#list#toggleTODO()<CR>
vnoremap <silent> <C-Space> :call anoter#list#toggleTODO()<CR>
nnoremap <silent> <leader>wd :call anoter#list#WONTDO()<CR>

nnoremap <silent> <CR> :call anoter#link#follow()<CR>
nnoremap <silent> <Tab> :call anoter#link#findNext()<CR>
nnoremap <silent> <S-Tab> :call anoter#link#findPrev()<CR>
