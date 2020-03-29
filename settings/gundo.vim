" Gundo
if has_key(plugs, 'gundo.vim')

let g:gundo_width          = 60
let g:gundo_preview_height = 40
let g:gundo_right          = 1

nnoremap <silent> <F5> :GundoToggle<CR>

endif
