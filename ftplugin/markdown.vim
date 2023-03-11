" anoter - minimalist wiki plugin for (neo)vim.
" Author: Pedro Augusto Santana
" License: MIT

nnoremap <buffer><silent><C-Space> :call anoter#list#toggle()<CR>
nnoremap <buffer><silent><leader>wd :call anoter#list#wontDo()<CR>
nnoremap <buffer><silent><Tab> :call anoter#link#findNext()<CR>
nnoremap <buffer><silent><S-Tab> :call anoter#link#findPrev()<CR>
nnoremap <buffer><silent><CR> :call anoter#link#follow()<CR>
