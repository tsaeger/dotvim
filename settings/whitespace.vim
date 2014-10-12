" remove trailing whitespace
nnoremap <leader>S :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" FixWhiteSpace
" let g:extra_whitespace_ignored_filetypes = ['unite', '\[unite\]', 'mkd']
