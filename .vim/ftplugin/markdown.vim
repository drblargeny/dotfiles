" Markdown specific settings

" Enable line wrapping
setlocal wrap

" Wrap lines at 78 characters 
setlocal textwidth=78

" Enable spell checking
setlocal spell

" Enable automatic conversion of markdown to the appropriate html on save
" using external pandoc command
"autocmd BufWritePost <buffer> silent !pandoc --standalone --toc --output=%.html %

