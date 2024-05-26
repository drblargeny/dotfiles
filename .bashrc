# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.3-3

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# Cygwin work-around for when HOME is already set by Windows (e.g. HOME set to %HOMEDRIVE%%HOMEPATH%)
export HOME="${HOME%/}"

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# If any jobs are running, this causes the exit to be deferred until a second
# exit is attempted without an intervening command
shopt -s checkjobs

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If not set, bash removes metacharacters such as the dollar sign from the
# set of characters that will be quoted in completed filenames when these
# metacharac‐ ters  appear  in shell variable references in words to be
# completed.  This means that dollar signs in variable names that expand to
# directories will not be quoted; however, any dollar signs appearing in
# filenames will not be quoted, either.  This is  active  only when  bash  is
# using backslashes to quote completed filenames.
shopt -s complete_fullquote

# whenever bash sees foo.exe during completion, it checks if foo is the
# same file and strips the suffix
# This is only an option under Cygwin
command -v cygpath >/dev/null && shopt -s completion_strip_exe

# bash will not attempt to search the PATH for possible completions when
# completion is  attempted on an empty line
shopt -s no_empty_cmd_completion

# Programmable completion enhancements are enabled via
# /etc/profile.d/bash_completion.sh when the package bash_completetion
# is installed.  Any completions you add in ~/.bash_completion are
# sourced last.

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Don't put duplicate lines in the history and ignore lines that begin with space
export HISTCONTROL=ignoreboth
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"
#
# Add timestamp to history lines
export HISTTIMEFORMAT="%F %T "

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# Rather than ask after removing each file, only ask if there are more than 3 files
#alias rm='rm -I'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color=auto'                # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias ls='ls -hp --color=auto'                # add slash indicators to directories in colour
alias ls='ls -hp --color=auto --quoting-style=escape'   # add slash indicators to directories in colour and escape with slashes
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l --quoting-style=escape'      # long list
alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# rsync display options
alias rsync='rsync -z --progress'

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Define function for setting the prompt and status line
. ~/.bashrc.d/_bash_prompt_function.sh
# Setup default prompt
_bash_prompt_function '' "$debian_chroot"

# Override the default color scheme for ls
#Original
#LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:';
LS_COLORS='no=00:fi=00:di=00;01:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:';
export LS_COLORS

# settings for less
#
# NOTE: If these defaults need to be ignored/changed for a particular less
#       instance, add + to the argument to revert to default less behavior. For
#       example, to disable interpreting color escape sequences use: 
#       less -+R
#
# -M    Causes less to prompt even more verbosely than more (shows file name
#       and byte/relative position
# -R    only ANSI "color" escape sequences are output in "raw" form
# -S    lines longer than the screen width to be chopped (truncated)
# -X    Disables  sending  the  termcap initialization and deinitialization
#       strings to the terminal.  This is sometimes desirable if the
#       deinitialization string does something unnecessary, like clearing the
#       screen.
# -W    temporarily highlights the first new line after any forward movement
#       command larger than one line.
# -n    Suppresses  line  numbers.  The default (to use line numbers) may cause
#       less to run more slowly in some cases
export LESS="MRSXWn"

# Setup TMPDIR, TEMP and TMP
if [ -z "$TMPDIR" ]; then
#    echo Setting TMPDIR
    export TMPDIR=/tmp;
#else
#    echo TMPDIR=$TMPDIR
fi
if [ -z "$TEMP" ]; then
#    echo Setting TEMP
    export TEMP=/tmp;
#else
#    echo TEMP=$TEMP
fi
if [ -z "$TMP" ]; then
#    echo Setting TMP
    export TMP=/tmp;
#else
#    echo TMP=$TMP
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    # NOTE: Use absolute path to avoid security issues with relative paths
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    # NOTE: Use absolute path to avoid security issues with relative paths
    export PATH="$HOME/.local/bin:$PATH"
fi

# Setup vimasaur (vim as our) editor
export SVN_EDITOR=vim
export EDITOR=vim
export VISUAL=vim

# Bash configuration for this host
if [ -f ~/.bashrc.d/host."$HOSTNAME" ]; then
    . ~/.bashrc.d/host."$HOSTNAME" 
fi

# Auto-start ssh-agent
if [ -f ~/.bashrc.d/.ssh-agent-autostart-enabled ]; then
    . ~/.bashrc.d/ssh-agent
fi

# Load Python aliases if python command exists
[ -n "$(command -v python)" ] && . ~/.bashrc.d/python-aliases

# Source the alias to provide Git versioning of dotfiles
. ~/.dotfiles-bin/config-alias.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -z "$BASH_COMPLETION_VERSINFO" ]; then
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR=`readlink -f ~/.sdkman`
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
