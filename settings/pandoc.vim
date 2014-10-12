" Pandoc
nnoremap <silent> <Leader>panh :!pandoc "%" -o "%.html"<CR>
nnoremap <silent> <Leader>panp :!pandoc "%" --toc --chapters -N -o "%.pdf"<CR>
nnoremap <silent> <Leader>pans :!pandoc "%" --toc --chapters -N --to=dzslides -o "%.html"<CR>
nnoremap <leader>act :.!cat "%" \| egrep "\\$"<CR>
