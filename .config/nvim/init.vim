" Neovim configuration, converted from ~/.vimrc
"
" Maintainer:	Jacob Bolton <j.m.bolton@gmail.com>
"
" Options that are always on / already the default in Neovim (nocompatible,
" incsearch, ruler, showcmd, wildmenu, hidden-friendly history, autoindent,
" display=truncate, backspace, ttimeout, nrformats, filetype plugin indent,
" syntax on, laststatus=2, mouse, langremap, matchit, etc.) are still stated
" explicitly where harmless so the intent stays visible.

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Ensure VIM_TEMP environment variable is set as it will be used to specify
" where swap, backup and undo files will be stored
if $VIM_TEMP == ""
  " Default to ~/.vim-temp
  let $VIM_TEMP = expand('~') . "/.vim-temp"
endif
" Ensure the $VIM_TEMP directory exists
if !isdirectory($VIM_TEMP)
  " Create it if necessary along with any intermediate paths
  call mkdir($VIM_TEMP, "p", 0700)
endif

" Put swap, backup and undo files in $VIM_TEMP by default rather than in the
" same folder with the file.
" NOTE: Appending // to end to trigger file name expansion
set directory^=$VIM_TEMP//
set backup
set backupdir^=$VIM_TEMP//
set undofile
set undodir^=$VIM_TEMP//

set backspace=indent,eol,start
set history=10000
set ruler
set showcmd
set scrolloff=5
set incsearch
set nrformats-=octal
set nomodeline
set wildmenu

" Don't use Ex mode, use Q for formatting.
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo.
inoremap <C-U> <C-G>u<C-U>

set mouse=a

syntax on
set hlsearch
" Stop the highlighting until the next search
nohlsearch

" I like highlighting strings inside C comments.
let c_comment_strings = 1

" Enable file type detection, plugins and indenting
filetype plugin indent on

augroup vimStartup
  au!
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
augroup END

" My customizations get their own group so they don't conflict
augroup jbolton_rpmpcg
  au!
  " xmllint should use the same indentation as vim (as defined by shiftwidth)
  autocmd OptionSet shiftwidth let $XMLLINT_INDENT=repeat(" ", &shiftwidth)
augroup END

set autoindent

" Convenient command to see the difference between the current buffer and the
" file it was loaded from.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

set nolangremap

" The matchit plugin makes the % command work better
packadd matchit

set noinsertmode

" Make a buffer hidden when editing another one
set hidden

" Make cursor keys ignore wrapping
inoremap <silent> <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <silent> <Up> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>

colorscheme koehler

" Always use regexp magic
set magic

" Prefer unix file format, but recognize DOS when reading it
set fileformat=unix
set fileformats=unix,dos

" Don't wrap lines by default
set nowrap

" GUI font (e.g. nvim-qt)
set guifont=JuliaMono:h12,DejaVu\ Sans\ Mono:h12,Consolas:h12,Courier\ New:h12

" Unicode support (Neovim's internal encoding is always UTF-8)
" Default encodings for reading files
set fileencodings-=ucs-bom
set fileencodings-=utf-8
set fileencodings^=ucs-bom,utf-8

" Show whitespace as characters
set list
set listchars=eol:¶,tab:»\ ,space:·,trail:·,extends:…,precedes:…,conceal:§,nbsp:␣

" Visually indicate wrapped text
set showbreak=↪\

" to have newly created files use UTF-8 encoding
setglobal fileencoding=utf-8

" Do not use BOM since that is not recommended for UTF-8
setglobal nobomb

"------------------------------------------------------------
" Usability options

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Stop certain movements from always going to the first character of a line.
set nostartofline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Raise a dialogue asking to save changed files instead of failing
set confirm

set novisualbell

" Set the command window height to 2 lines
set cmdheight=2

" Display line numbers on the left (by default)
set number

" Display cursor line by default when not in diff mode
if !&diff
  set cursorline
endif

" Use <F12> to toggle line numbers
noremap  <silent> <F12> <Cmd>set number!<CR>
inoremap <silent> <F12> <C-o><Cmd>set number!<CR>

" Use <S-F12> to toggle relative line numbers
noremap  <silent> <S-F12> <Cmd>set relativenumber!<CR>
inoremap <silent> <S-F12> <C-o><Cmd>set relativenumber!<CR>

" Use <C-F12> to toggle cursor line
noremap  <silent> <C-F12> <Cmd>set cursorline!<CR>
inoremap <silent> <C-F12> <C-o><Cmd>set cursorline!<CR>

" Use <C-S-F12> to toggle cursor column
noremap  <silent> <C-S-F12> <Cmd>set cursorcolumn!<CR>
inoremap <silent> <C-S-F12> <C-o><Cmd>set cursorcolumn!<CR>

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Function to toggle line length rulers
function! ToggleColorcolumn()
  if &colorcolumn =~ "^\\s*$"
    set colorcolumn=50,72,80,100
  else
    set colorcolumn=
  endif
endfunction

" Start with column rulers active
call ToggleColorcolumn()

" Use <F11> to toggle rulers
noremap  <silent> <F11> <Cmd>call ToggleColorcolumn()<CR>
inoremap <silent> <F11> <C-o><Cmd>call ToggleColorcolumn()<CR>

" Use <S-F11> to toggle between 'paste' and 'nopaste'
" ('pastetoggle' was removed from Neovim; bracketed paste is handled natively)
noremap  <silent> <S-F11> <Cmd>set paste!<CR>
inoremap <silent> <S-F11> <C-o><Cmd>set paste!<CR>

"------------------------------------------------------------
" Indentation options

" Use 2 spaces instead of tabs.
set shiftwidth=2
set softtabstop=2
set expandtab

" xmllint should use the same indentation as vim (as defined by shiftwidth)
let $XMLLINT_INDENT = repeat(" ", &shiftwidth)

"------------------------------------------------------------
" Mappings

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<CR><C-L>

" Map <C-m> to format MANIFEST.MF Dependency lines for human readability
map <C-m> <Cmd>%s/^Dependencies:\s*[^\n]\+\(\n\s[^\n]*\)*/\=substitute(submatch("0"), "\n ", "", "ge")/e<CR>:/^Dependencies:/s/,/,<C-v><CR> /ge<CR>

" Map <F9> to produce the current date in ISO-8601 format
noremap <silent> <F9> "=strftime("%Y-%m-%d")<CR>p
noremap <silent> <S-F9> "=strftime("%Y-%m-%d")<CR>P
inoremap <silent> <F9> <C-R>=strftime("%Y-%m-%d")<CR>

" Map <C-F9> to produce the current time in ISO-8601 format
noremap <silent> <C-F9> "=strftime("T%H:%M:%S")<CR>p
noremap <silent> <C-S-F9> "=strftime("T%H:%M:%S")<CR>P
inoremap <silent> <C-F9> <C-R>=strftime("T%H:%M:%S")<CR>

" NOTE: <C-F> "promptfind" mappings from the vimrc are omitted: :promptfind is
" a Windows gVim-only command and does not exist in Neovim.

"------------------------------------------------------------

" Enable the use of MinGW/MSYS and Cygwin commands
" The expectation here is that command priority is: MinGW -> Cygwin -> Normal PATH
if exists("$CYGWIN_HOME")
  let $PATH = $CYGWIN_HOME.'\bin;'.$PATH
endif
if exists("$MSYS_HOME")
  let $PATH = $MSYS_HOME  .'\bin;'.$PATH
endif
if exists("$MINGW_HOME")
  let $PATH = $MINGW_HOME .'\bin;'.$PATH
endif

" Add extra info to status line about char under cursor
set statusline=%2(%n%)%(%{&modified==0?'\ ':'+'}%{&modifiable==0?'-':'\ '}%{&readonly==0?'\ ':'-'}%)\ %(%<%f%)\ %([%{&filetype==''?'':&filetype.'/'}%{&fileencoding==''?'':&fileencoding.'/'}%{strpart(&fileformat,0,1)}]%h%w%)%=%(%3b\ 0x%02B%)\ %(%4l,%-7(%c%V%)%)\ %(%P\ 0x%04O%)

" Default :TOhtml to not use CSS
let g:html_use_css = 0

" Allow alt to work properly for entering extended characters
" (the 'winaltkeys' option is GUI-menu related and not present in Neovim)

" Use original default String to put the output of a filter command in a
" temporary file (keep stderr out of the output).
set shellredir=>

" Setup a macro for converting emails to file names
let @e = ":%dV\"+Pj3f\tld$gg0Pa-j0dt\tk3f-pa-?\\Sldt-jdd0:s/-//|s|s/ /T/|s/://|s/[\\/:*?\"<>|]/_/ge|s/\\s\\+$//e\"+y$"

" Setup shortcut to paste clipboard into a search while escaping special
" characters
cnoremap <C-E>    <C-R>=substitute(@+,"[/$.*\\\\]","\\\\\\0","g")<CR>
