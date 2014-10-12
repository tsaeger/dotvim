
" colorscheme
set background=dark
colorscheme industry
" colorscheme morning
" colorscheme ron
" colorscheme solarized
" colorscheme vividchalk
" colorscheme mac_classic
" colorscheme ronned

" ctags
set tags=./tags,tags,/home/tsaeger/tags

" egrep
nnoremap <leader>g :!egrep -Rin --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" --exclude-dir=".git" "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
nnoremap <leader>fig :!git grep -n "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>

" out.txt error file
nnoremap <leader>r :cfile out.txt<cr>:cope<cr>

" Insert date timestamp
nnoremap <leader>dts "=strftime("%c")<CR>P

" Visually select the text that was last edited/pasted
nnoremap gV `[v`]

let s:settingspath = fnameescape(join([expand('<sfile>:p:h'),'/settings'], ''))  " settings
" echo "settingspath:" . s:settingspath
for fpath in split(globpath(s:settingspath, '*.vim'), '\n')
  " echo "sourcing:" . fpath
  execute "source" fpath
endfor

" vim:ft=vim:ts=4:sw=4:et:fdm=marker:commentstring=\"\ %s:nowrap
