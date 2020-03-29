" airline
if has_key(plugs, 'vim-airline')

let g:airline_theme                        = 'badwolf'
let g:airline_detect_modified              = 1
let g:airline_detect_paste                 = 1
let g:airline#extensions#branch#enabled    = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#hunks#enabled     = 1
let g:airline#extensions#tmuxline#enabled  = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.paste         = 'ρ'

" tmuxline - keep with airline
let g:tmuxline_powerline_separators = 0
let g:tmuxline_separators = {
  \ 'left' : '',
  \ 'left_alt': '>',
  \ 'right' : '',
  \ 'right_alt' : '<',
  \ 'space' : ' '}


set laststatus=2

endif
