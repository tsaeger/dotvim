" Fugitive
" autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif
