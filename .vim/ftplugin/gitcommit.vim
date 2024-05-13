" Git commit specific settings

" Apply any settings for text files
runtime ftplugin/text.vim

" Automatically wrap lines at 72 characters (for body)
" NOTE: First line should be limited to 50 characters
" See: https://git-scm.com/docs/git-commit#_discussion
" See: https://sethrobertson.github.io/GitBestPractices/#do-make-useful-commit-messages
" See: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
set textwidth=72

" Higlight columns 50 and 72
set colorcolumn=50,72

