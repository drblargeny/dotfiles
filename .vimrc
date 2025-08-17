" A vimrc file based on prefs and examples, to name a few:
"
"   vimrc_example.vim - 2011 Apr 15
"      I used to source it, but it's simpler to use only one .vimrc
"
"   http://vim.wikia.com/wiki/Example_vimrc - version 7.0
"      Got some nifty ideas from this
"
" Maintainer:	Jacob Bolton <j.m.bolton@gmail.com>
" Last change:	2015-04-17
"
" To use it, copy it to: $HOME/.vimrc

" Don't use Vi-compatible mode.
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Try to prevent loading anything from mswin.vim
let g:skip_loading_mswin = 1

" Allow backspacing over everything in insert mode.
" set backspace=2		" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" TODO May want to consider implementing something like this:
" http://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile

" Ensure VIM_TEMP environment variable is set as it will be used to specify
" where swap and undo files will be stored
if $VIM_TEMP == ""
    " Default to ~/.vim-temp
    let $VIM_TEMP=$HOME."/.vim-temp"
endif
" Ensure the $VIM_TEMP directory exists
if !isdirectory($VIM_TEMP)
    " Create it if necessary along with any intermediate paths
    call mkdir($VIM_TEMP, "p", 0700)
endif

" Put swap files in $VIM_TEMP by default rather than in the same folder with
" the file (keeps directory cleaner) and avoids security issues with using
" $TEMP
" NOTE: Appending // to end to trigger file name expansion
set dir^=$VIM_TEMP//

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  " Put backup files in $VIM_TEMP by default to prevent clutter
  " NOTE: Appending // to end to trigger file name expansion
  set backupdir^=$VIM_TEMP//
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
    " Also put the undo files in $VIM_TEMP by default
    " NOTE: Appending // to end to trigger file name expansion
    set undodir^=$VIM_TEMP//
  endif
endif

set history=10000		" keep 10000 (max) lines of command line history
if !has('nvim')
  " Also change the viminfo settings:
  " This was the default: TODO Find where this was the default, evim.vim?
  "set viminfo='100,<50,s10,h,rA:,rB:
  set viminfo='100,f1,s10,h,rA:,rB:,c,n$HOME/.viminfo
endif
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
if version < 800
  set display=lastline
else
  set display=truncate
endif

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch		" do incremental searching
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
" TODO: Evaluate need for this
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on
  " Switch on highlighting the last used search pattern.
  " Can use <C-L> to temporarily turn off highlighting; see the mapping of
  " <C-L> below
  set hlsearch

  " Stop the highlighting for the 'hlsearch' option.  It is automatically
  " turned back on when using a search command, or setting the 'hlsearch'
  " option.
  " NOTE: originally from $VIMRUNTIME/evim.vim
  nohlsearch

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
  autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  augroup END

  " My customizations get their own group so they don't conflict
  augroup jbolton_rpmpcg
  au!

  if version >= 800
    " xmllint should use the same indentation as vim (as defined by shiftwidth)
    " see: let $XMLLINT_INDENT
    autocmd OptionSet shiftwidth let $XMLLINT_INDENT=repeat(" ", &shiftwidth)
  endif

  augroup END

"else
endif " has("autocmd")

" NOTE: This was within an else block for the if above
  " When opening a new line and no filetype-specific indenting is enabled, keep
  " the same indent as the line you're currently on. Useful for READMEs, etc.
  set autoindent		" always set autoindenting on

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval') && exists('packadd')
  packadd matchit
endif
" Don't want Insert mode by default
" evim.vim uses this, but too many CTRL-O to get into normal mode
set noinsertmode

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
" Make a buffer hidden when editing another one
"   From evim.vim
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" NOTE: This is set below
" set confirm
" set autowriteall

" Make cursor keys ignore wrapping
"   From evim.vim
" TODO Use tips from this to fix issue with omnicompletion:
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
inoremap <silent> <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <silent> <Up> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>

" Diff implementation (Only needed for Windows gVim)
if has('win32') && !has('nvim')
" NOTE: Some (windows) releases ship with a broken version of this, best to
" use one that works
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
endif

colorscheme koehler

" Always use regexp magic
set magic

" Prefer unix file format, but recognize DOS when reading it
set fileformat=unix
set fileformats=unix,dos

" Don't wrap lines by default
set nowrap

" GUI font: 
" 1. DejaVu Sans Mono - has more Unicode Glyphs
"    http://dejavu-fonts.org/wiki/Main_Page
" 2. Consolas - Available on Windows
" 3. Courier New - Available on many systems
if has('nvim')
  set guifont=DejaVu\ Sans\ Mono:h12:cDEFAULT,Consolas:h12:cDEFAULT,Courier\ New:h12:cDEFAULT
else
  set guifont=DejaVu_Sans_Mono:h12:cDEFAULT,Consolas:h12:cDEFAULT,Courier_New:h12:b:cDEFAULT
endif

" Unicode support: http://vim.wikia.com/wiki/Working_with_Unicode
" Also see: http://www.vim.org/scripts/script.php?script_id=789
" Only apply it when VIM supports it
if has("multi_byte")
  " Preserve input encoding
  if exists("+termencoding") && (&termencoding == "")
    let &termencoding = &encoding
  endif

  " if "printencoding" is supported, avoid messing it up
  if exists("+printencoding") && (&printencoding == "")
    let &printencoding = &encoding
  endif

  " Default encodings for reading files
  " 1. Use a BOM
  " 2. Use UTF-8
  " 3. Use 8-bit latin1
  " make sure that existing Unicode files will be recognised when possible
  set fileencodings-=ucs-bom
  set fileencodings-=utf-8
  if (&fileencodings == "") && (&encoding != "utf-8")
    let &fileencodings = &encoding
  endif  
  set fileencodings^=ucs-bom,utf-8

  " Use UTF-8 by default
  set encoding=utf-8

  " Show whitespace as characters
  set list
  if has("patch-7.4.1024")
    " You must use 7.4.1024 or newer for these:
    set listchars=eol:¶,tab:»\ ,space:·,trail:·,extends:…,precedes:…,conceal:§,nbsp:␣
  else
    " NOTE: The original vim 7.4 release for windows only supported these
    " options:
    set listchars=eol:¶,tab:»\ ,trail:·,extends:…,precedes:…,conceal:§,nbsp:•
  endif

  " Vistually indicate wrapped text
  set showbreak=↪\ 

  " to have newly created files use UTF-8 encoding
  setglobal fileencoding=utf-8

  " Do not use BOM since that is not recommended for UTF-8
  setglobal nobomb

endif


" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.


" Better command-line completion
set wildmenu		" display completion matches in a status line

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" NOTE: may or may not have securemodelines setup
set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Don't use visual bell instead of beeping when doing something wrong
" I don't like visual bell because the screen flash can be distracting and may not be
" perceivable
set novisualbell

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left (by default)
set number

" Display cursor line by default when not in diff mode
" This is done because the coloring for the status line in diuff mode can
" interfere with the coloring of the diff making it difficult to distinguish
" the changes.
" NOTE: This only applies when vim is started in diff mode. If it is started
"       without diff mode and is then switched to, the cursorline will nee to
"       be disabled manually.
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
function ToggleColorcolumn()
  if &colorcolumn =~ "^\\s*$"
    " https://en.wikipedia.org/wiki/Line_length#Electronic_text
    " https://google.github.io/styleguide/javaguide.html#s4.4-column-limit
    " https://sethrobertson.github.io/GitBestPractices/#usemsg
    " https://www.researchgate.net/publication/234578707_Optimal_Line_Length_in_Reading--A_Literature_Review
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
if exists("+pastetoggle")
  set pastetoggle=<S-F11>
endif

"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
"set shiftwidth=4
"set softtabstop=4
set shiftwidth=2
set softtabstop=2
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=4
"set tabstop=4

" xmllint should use the same indentation as vim (as defined by shiftwidth)
" see: autocmd OptionSet shiftwidth
let $XMLLINT_INDENT=repeat(" ", &shiftwidth)


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" CTRL-F does Find dialog instead of page forward
noremap <silent> <C-F> <Cmd>promptfind<CR>
vnoremap <silent> <C-F> y<Cmd>promptfind <C-R>"<CR>
onoremap <silent> <C-F> <C-C><Cmd>promptfind<CR>
inoremap <silent> <C-F> <C-O><Cmd>promptfind<CR>
cnoremap <silent> <C-F> <C-C><Cmd>promptfind<CR>

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
"------------------------------------------------------------

" Enable the use of MinGW/MSYS and Cygwin commands
" The expectation here is that command priority is: MinGW -> Cygwin -> Normal PATH
" This is done because there are some .bat files in my normal path that would
" prevent normal *NIX commands from working
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

" Disable Alt keys for GUI menus
" This allows alt to work properly for entering extended characters (e.g. æ å
" ô ó â ÷ ä è)
set winaltkeys=no

if !has('nvim')
  " Use medium/strong cypher when using encryption
  set cryptmethod=blowfish2
endif

" Use original default String to put the output of a filter command in a
" temporary file. This option is changed automatically by Vim based on the
" current shell setting.  Apparently, the idea is that in instances where no
" terminal may available to see stderr the user should see stderr in the
" output sent to vim.  Otherwise that output would be lost.   However, I
" typically don't want to see that output.
set shellredir=>

" Setup a macro for converting emails to file names
let @e=":%dV\"+Pj3f	ld$gg0Pa-j0dt	k3f-pa-?\\Sldt-jdd0:s/-//|s|s/ /T/|s/://|s/[\\/:*?\"<>|]/_/ge|s/\\s\\+$//e\"+y$"

" Setup shortcut to paste clipboard into a search while escaping special
" characters
cnoremap <C-E>    <C-R>=substitute(@+,"[/$.*\\\\]","\\\\\\0","g")<CR>

