# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.3-3

# ~/.bashrc: executed by bash(1) for interactive non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Add timestamp to history lines
export HISTTIMEFORMAT="%F %T "

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Functions
#
# Auto-load functions from ~/.bashrc.d/functions/
for func_file in ~/.bashrc.d/functions/*; do
    source "$func_file"
done
# Some people use a different file for functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Setup default prompt and status line
_bash_prompt_function '' "${debian_chroot:+($debian_chroot)}"

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null; then
    for DIR_COLORS in ~/.dircolors.d/{256,16,8}/.dircolors; do
        [[ -r "$DIR_COLORS" && ( $TERM__COLORS = $colors || $TERM__COLORS > $colors ) ]] && break
        unset DIR_COLORS
    done
    if [[ -z "$DIR_COLORS" ]]; then
        for DIR_COLORS in ~/.dir{_,}colors /etc/DIR{_,}COLORS; do
            [[ -r "$DIR_COLORS" ]] && break
        done
    fi
    #echo "$DIR_COLORS"
    test -r "$DIR_COLORS" && eval "$(dircolors -b $DIR_COLORS)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
#
# Some people use a different file for aliases
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
alias rm='rm -i'                          # confirm before deleting something
alias cp='cp -i'                          # confirm before overwriting something
alias mv='mv -i'                          # confirm before moving something
# Rather than ask after removing each file, only ask if there are more than 3 files
#alias rm='rm -I'

# Default to human readable figures
alias df='df -h'
alias du='du -h'
alias free='free -m'                      # show sizes in MB

# Misc :)
#alias less='less -r'                          # raw control characters
#alias more=less
#alias np='nano -w PKGBUILD'
#alias whence='type -a'                        # where, of a sort
[[ "$TERM__COLORS" > 0 ]] && color_auto='--color=auto' || color_auto=
alias grep="grep $color_auto"                # show differences in colour
alias egrep="egrep $color_auto"              # show differences in colour
alias fgrep="fgrep $color_auto"              # show differences in colour

# Some shortcuts for different directory listings
alias ls="ls -hp $color_auto --quoting-style=escape"   # add slash indicators to directories in colour and escape with slashes
if command -v dir >/dev/null; then
  alias dir="dir $color_auto"
else
  alias dir="ls $color_auto --format=vertical"
fi
if command -v vdir >/dev/null; then
  alias vdir="vdir $color_auto"
else
  alias vdir="ls $color_auto --format=long"
fi
# some more ls aliases
alias ll="ls $color_auto -l --quoting-style=escape"      # long list
alias la="ls $color_auto -A"                              # all but . and ..
alias l="ls $color_auto -CF"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# rsync display options
alias rsync='rsync -z --progress'

unset color_auto

# Load Python aliases if python command exists
[ -n "$(command -v python)" ] && . ~/.bashrc.d/python-aliases

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

shopt -s expand_aliases

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


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

# export QT_SELECT=4

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

# Source the alias to provide Git versioning of dotfiles
. ~/.dotfiles-bin/config-alias.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -z "$BASH_COMPLETION_VERSINFO" ]; then
  if ! shopt -oq posix; then
    if [ -r /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR=`readlink -f ~/.sdkman`
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
