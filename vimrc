" Tom Saeger
"
" Pathogen setup {{{1
"Get out of VI's compatible mode..
set nocompatible
call pathogen#infect()
call pathogen#helptags()
" }}}
" General {{{1
" colorscheme {{{2
"set background=light
set background=dark
"set default colorscheme"
"colorscheme morning
"colorscheme ron
"colorscheme solarized
"colorscheme vividchalk
"colorscheme mac_classic
colorscheme ronned
" }}}
"Case-sensitive searches - s/lower/ will ignore case
set ignorecase smartcase incsearch

"Set shell to be zsh
set shell=zsh

"Sets how many lines of history VIM bar to remember
set history=400

"Enable filetype plugin
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
set mouse=a

"Syntax
syntax on
" }}}
" File formats {{{1
"Favorite filetypes
set ffs=unix,dos,mac

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>
" }}}
" Plugins {{{1
" Taglist {{{2
"let Tlist_Ctags_Cmd='~/local/bin/ctags -R --fields=afmikKlnsStz'
"let Tlist_Ctags_Cmd='/usr/bin/ctags -R --fields=afiKmsSzn'
"let Tlist_Ctags_Cmd='ctags -R --c++-kinds=+px --c-kinds=+px --fields=+afmikKlnsStz --extra=+q'
let Tlist_Use_Right_Window = 1
" }}}
" Fugitive {{{2
autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif
" }}}
" }}}
" Keymaps {{{1
" Keymaps
" Fast saving {{{2
nmap <leader>w :w!<cr>
nmap <leader>f :e ~/buffer<cr>
" }}}
" Taglist {{{2
nnoremap <silent> <F8> :Tlist<CR>
nnoremap <silent> <F7> :TlistUpdate<CR>
nnoremap <silent> <Leader>ts :Tlist<CR>
nnoremap <silent> <Leader>tu :TlistUpdate<CR>
" }}}
" Gundo {{{2
nnoremap <silent> <F5> :GundoToggle<CR>
" }}}
" Invisibles {{{2
nnoremap <silent> <Leader>rw :call Cream_list_toggle("n")<CR>
" }}}
" Doxygen {{{2
nnoremap <silent> <Leader>dc :Dox<CR>
" }}}
" Pandoc {{{2
nnoremap <silent> <Leader>panh :!pandoc "%" -o "%.html"<CR>
nnoremap <silent> <Leader>panp :!pandoc "%" --toc --chapters -N -o "%.pdf"<CR>
nnoremap <silent> <Leader>pans :!pandoc "%" --toc --chapters -N --to=dzslides -o "%.html"<CR>
nnoremap <leader>act :.!cat "%" \| egrep "\\$"<CR>
" }}}
" remove trailing whitespace {{{2
nnoremap <leader>S :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" }}}
" egrep {{{2
nnoremap <leader>g :!egrep -Rin --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" --exclude-dir=".git" "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
" }}}
" open out.txt as the error file {{{2
nnoremap <leader>r :cfile out.txt<cr>:cope<cr>
" }}}
" Line Bubbling (with unimpaired) {{{2
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
" }}}
" Visually select the text that was last edited/pasted {{{2
nmap gV `[v`]
" }}}
" Insert date timestamp
nnoremap <leader>dts "=strftime("%c")<CR>P
" }}}
" }}}
" Tabs {{{1
"set ts=4 sw=4 sts=4 et
set ts=8 sw=8 sts=8 noet
map <leader>ne :set ts=4 sw=4 sts=4 et<cr>
map <leader>ke :set ts=8 sw=8 sts=8 noet<cr>

" }}}
" Misc {{{1
set tags=./tags,tags,/home/tsaeger/tags
"set foldmethod=syntax

"Turn on Wild menu
set wildmenu

"Always show current position
set ruler

"Show line number
"set nu

"Do not redraw, when running macros.. lazyredraw
"set lz

"Change buffer - without saving
set hid

"Set backspace
set backspace=eol,start,indent

"Pastetoggle
set pastetoggle=<F12>

" }}}
" Visual Search {{{1
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    else
        execute "normal /" . l:pattern . "^M"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" }}}
" File type mappings {{{1
" Python {{{2
    autocmd BufNewFile,BufRead *.py map <buffer> <leader><space> :w!<cr>:!python %<cr>
    autocmd BufNewFile,BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd BufNewFile,BufRead *.py nmap <buffer> <leader>cc :w!<cr>:make<cr>
" }}}
" Ruby {{{2
    autocmd BufNewFile,BufRead *.rb map <buffer> <leader><space> :w!<cr>:!ruby %<cr>
" }}}
" C/C++ {{{2
    autocmd BufNewFile,BufRead *.cpp map <buffer> <leader><space> :w<cr>:make<cr>
    autocmd BufNewFile,BufRead *.c map <buffer> <leader><space> :w<cr>:make<cr>
" }}}
" bash {{{2
    autocmd BufNewFile,BufRead *.sh map <buffer> <leader><space> :w!<cr>:!./%<cr>
" }}}
" Lua {{{2
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.lua map <buffer> <leader><space> :w!<cr>:!lua %<cr>
    autocmd BufNewFile,BufRead *.lua map <buffer> <leader>i :w!<cr>:!lua -i %<cr>
    autocmd BufNewFile,BufRead *.lua set makeprg=luac\ -o\ /dev/null\ -l\ %
    autocmd BufNewFile,BufRead *.lua nmap <buffer> <leader>cc :w!<cr>:make<cr>
    autocmd BufNewFile,BufRead *.lua nmap <buffer> <leader>cg :w!<cr>:!luac -o /dev/null -l % \|egrep "GETGLOBAL" \|perl -pe 's/.*; (.*)/local $1 = _G.$1/;' \|sort \|uniq<cr>
    autocmd BufNewFile,BufRead *.lua map <buffer> <leader>head :r!cat ~/.vim/plugin/headers/lua.txt<cr>
" }}}
" php {{{2
    autocmd BufNewFile,BufRead *.php,*.inc setf php
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" }}}
" html {{{2
    autocmd BufNewFile,BufRead *.html,*.xhtml setf html
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" }}}
" css {{{2
    autocmd BufNewFile,BufRead *.css setf css
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
" }}}
" Javascript {{{2
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.js map <buffer> <leader><space> :w<cr>:make<cr>
    autocmd BufNewFile,BufRead *.js nmap <buffer> <leader>cg :w!<cr>:JSLint<cr>
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" }}}
" coffeescript {{{2
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.coffee map <buffer> <leader><space> :w<cr>:!coffee -bc %<cr>
    autocmd FileType coffeescript set omnifunc=javascriptcomplete#CompleteJS
" }}}
" PKGBUILD {{{2
    autocmd BufNewFile,BufRead *PKGBUILD* setf PKGBUILD
" }}}
" bitbake {{{2
    autocmd BufNewFile,BufRead *.bb,*.bbappend setf bitbake
" }}}
" GEL {{{2
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.gel setf c
" }}}
" }}}
" vimrc mgmt {{{1
"Fast reloading of the .vimrc
map <leader>s :source ~/.vimrc<cr>

"Fast editing of .vimrc
map <leader>e :e! ~/.vimrc<cr>

"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
" }}}
" vim:ft=vim:ts=4:sw=4:et:fdm=marker:commentstring=\"\ %s:nowrap
