" Taglist
"let Tlist_Ctags_Cmd='~/local/bin/ctags -R --fields=afmikKlnsStz'
"let Tlist_Ctags_Cmd='/usr/bin/ctags -R --fields=afiKmsSzn'
"let Tlist_Ctags_Cmd='ctags -R --c++-kinds=+px --c-kinds=+px --fields=+afmikKlnsStz --extra=+qf'
"let Tlist_Ctags_Cmd='ctags -R --extra=+qf --c++-kinds=+p --fields=+iaS'
"let Tlist_Ctags_Cmd='ctags -R --extra=+qf'
let Tlist_Use_Right_Window = 1
nnoremap <expr> gf empty(taglist(expand('<cfile>'))) ? "gf" : ":ta <C-r><C-f><CR>"
nnoremap <expr> <C-w>f empty(taglist(expand('<cfile>'))) ? "\<C-w>f" :":stj <C-r><C-f><CR>" 

nnoremap <silent> <F8> :Tlist<CR>
nnoremap <silent> <F7> :TlistUpdate<CR>
nnoremap <silent> <Leader>ts :Tlist<CR>
nnoremap <silent> <Leader>tu :TlistUpdate<CR>
