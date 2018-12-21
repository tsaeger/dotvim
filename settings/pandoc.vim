" Pandoc
nnoremap <silent> <Leader>panh :!pandoc "%" -o "%.html"<CR>
nnoremap <silent> <Leader>panp :!pandoc "%" --toc --top-level-division=chapter -N -o "%.pdf"<CR>
nnoremap <silent> <Leader>pans :!pandoc "%" --toc --top-level-division=chapter -N --to=dzslides -o "%.html"<CR>
nnoremap <leader>act :.!cat "%" \| egrep "\\$"<CR>
