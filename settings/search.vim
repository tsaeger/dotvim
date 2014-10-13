" egrep
" nnoremap <leader>g :!egrep -Rin --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" --exclude-dir=".git" "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
" nnoremap <leader>fig :!git grep -n "<cword>" . \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
" nnoremap <leader>g :!find . \( \( -path "*.hg" -type d \) -o \( -path "*.git" -type d \) -o \( -iname "*.out" -type f \) -o \( -iname "tags" -type f \) \) -prune -o -type f -print \|xargs egrep -Rin --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" "<cword>" \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
" nnoremap <leader>g :!cat files.txt \|xargs egrep -Rin --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" --exclude="TAGS" "<cword>" \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>
nnoremap <leader>g :!cat files.txt \|egrep -v ".*\\.c\|.*\\.h" \|xargs egrep -Rn --exclude="~/vimout.txt" --exclude="out.txt" --exclude="tags" --exclude="TAGS" "<cword>" \|tee ~/vimout.txt<cr>:cfile ~/vimout.txt<cr>:cope<cr>

" out.txt error file
nnoremap <leader>r :cfile out.txt<cr>:cope<cr>
