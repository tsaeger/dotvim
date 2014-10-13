" ctags
set tags=./tags,tags,/home/tsaeger/tags

" source all /settings/*.vim files
let s:mypath = fnamemodify(resolve(expand('<sfile>')), ':p:h')      " directory of this file
let s:settingspath = fnameescape(join([s:mypath,'/settings'], ''))  " settings
" echo "settingspath:" . s:settingspath
for fpath in split(globpath(s:settingspath, '*.vim'), '\n')
  " echo "sourcing:" . fpath
  execute "source" fpath
endfor

" vim:ft=vim:ts=4:sw=4:et:fdm=marker:commentstring=\"\ %s:nowrap
