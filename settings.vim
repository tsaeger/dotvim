
" default colorscheme
set background=dark
colorscheme industry
" colorscheme morning
" colorscheme ron
" colorscheme solarized
" colorscheme vividchalk
" colorscheme mac_classic
" colorscheme ronned

set tags=./tags,tags,/home/tsaeger/tags

" Taglist
"let Tlist_Ctags_Cmd='~/local/bin/ctags -R --fields=afmikKlnsStz'
"let Tlist_Ctags_Cmd='/usr/bin/ctags -R --fields=afiKmsSzn'
"let Tlist_Ctags_Cmd='ctags -R --c++-kinds=+px --c-kinds=+px --fields=+afmikKlnsStz --extra=+q'
let Tlist_Use_Right_Window = 1

" Fugitive
autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif

" Gitv
let g:Gitv_OpenHorizontal = 0
let g:Gitv_WipeAllOnClose = 0

" FixWhiteSpace
let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd']

" Ultisnips/Completion
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:ycm_path_to_python_interpreter="/usr/local/bin/python"
set completeopt-=preview
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" YankRing
" default disable yankring, use :YRToggle
let g:yankring_enabled = 0

" Unite
let g:unite_source_rec_max_cache_files = -1
let g:unite_source_history_yank_enable = 1

if executable('ag')
  " Use ag in unite grep source.
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  " For ack.
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '-i --no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
"nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
"nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>ug :<C-u>Unite -no-split -buffer-name=grep -start-insert grep<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>bb :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>

" Doxygen
nnoremap <silent> <Leader>dc :Dox<CR>

" Pandoc
nnoremap <silent> <Leader>panh :!pandoc "%" -o "%.html"<CR>
nnoremap <silent> <Leader>panp :!pandoc "%" --toc --chapters -N -o "%.pdf"<CR>
nnoremap <silent> <Leader>pans :!pandoc "%" --toc --chapters -N --to=dzslides -o "%.html"<CR>
nnoremap <leader>act :.!cat "%" \| egrep "\\$"<CR>

" remove trailing whitespace {{{2
nnoremap <leader>S :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" egrep
nnoremap <leader>g :!egrep -Rin --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" --exclude-dir=".git" "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
nnoremap <leader>fig :!git grep -n "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>

" open out.txt as the error file {{{2
nnoremap <leader>r :cfile out.txt<cr>:cope<cr>

" unimpaired
" Bubble single lines
nnoremap <C-Up> [e
nnoremap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Visually select the text that was last edited/pasted
nnoremap gV `[v`]

" Insert date timestamp
nnoremap <leader>dts "=strftime("%c")<CR>P

" Visual Search
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

" File type mappings
" Python
    autocmd BufNewFile,BufRead *.py map <buffer> <leader><space> :w!<cr>:!python %<cr>
    autocmd BufNewFile,BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd BufNewFile,BufRead *.py nnoremap <buffer> <leader>cc :w!<cr>:make<cr>

" Ruby
    autocmd BufNewFile,BufRead *.rb map <buffer> <leader><space> :w!<cr>:!ruby %<cr>
    autocmd BufNewFile,BufRead *.ru setf ruby

" C/C++
    autocmd BufNewFile,BufRead *.cpp map <buffer> <leader><space> :w<cr>:make<cr>
    autocmd BufNewFile,BufRead *.c map <buffer> <leader><space> :w<cr>:make<cr>

" bash
    autocmd BufNewFile,BufRead *.sh map <buffer> <leader><space> :w!<cr>:!./%<cr>

" Lua
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.lua map <buffer> <leader><space> :w!<cr>:!lua %<cr>
    autocmd BufNewFile,BufRead *.lua map <buffer> <leader>i :w!<cr>:!lua -i %<cr>
    autocmd BufNewFile,BufRead *.lua set makeprg=luac\ -o\ /dev/null\ -l\ %
    autocmd BufNewFile,BufRead *.lua nnoremap <buffer> <leader>cc :w!<cr>:make<cr>
    autocmd BufNewFile,BufRead *.lua nnoremap <buffer> <leader>cg :w!<cr>:!luac -o /dev/null -l % \|egrep "GETGLOBAL" \|perl -pe 's/.*; (.*)/local $1 = _G.$1/;' \|sort \|uniq<cr>
    autocmd BufNewFile,BufRead *.lua map <buffer> <leader>head :r!cat ~/.vim/plugin/headers/lua.txt<cr>

" Javascript
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.js map <buffer> <leader><space> :w<cr>:make<cr>
    autocmd BufNewFile,BufRead *.js nnoremap <buffer> <leader>cg :w!<cr>:JSLint<cr>
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" coffeescript
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.coffee map <buffer> <leader><space> :w<cr>:!coffee -bc %<cr>
    autocmd FileType coffeescript set omnifunc=javascriptcomplete#CompleteJS

" PKGBUILD
    autocmd BufNewFile,BufRead *PKGBUILD* setf PKGBUILD

" bitbake
    autocmd BufNewFile,BufRead *.bb,*.bbappend setf bitbake

" GEL
    set foldmethod=syntax
    autocmd BufNewFile,BufRead *.gel setf c


" vim:ft=vim:ts=4:sw=4:et:fdm=marker:commentstring=\"\ %s:nowrap
