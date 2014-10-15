" airline

let g:airline_theme                        = 'badwolf'
let g:airline_enable_branch                = 1
let g:airline_enable_syntastic             = 1
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
let g:tmuxline_powerline_separators = 0


set laststatus=2

