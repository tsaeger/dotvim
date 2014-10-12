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
