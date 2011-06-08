
set nocompatible

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

syntax enable
"set background=light
set background=dark
"colorscheme solarized
colorscheme vividchalk

autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif

