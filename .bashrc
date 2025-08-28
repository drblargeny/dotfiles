# ~/.bashrc: executed by bash(1) for interactive non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# Cygwin work-around for when HOME is already set by Windows (e.g. HOME set to %HOMEDRIVE%%HOMEPATH%)
export HOME="${HOME%/}"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
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
if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


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
if [ -d ~/bin ] ; then
    # NOTE: Use absolute path to avoid security issues with relative paths
    export PATH="${HOME}/bin:$PATH"
fi

# Setup default prompt and status line
_bash_prompt_function "${debian_chroot:+($debian_chroot)}"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    for dircolors in ~/.dircolors.d/{256,16,8}/.dircolors; do
        [[ -r "$dircolors" && ( $TERM__COLORS = $colors || $TERM__COLORS > $colors ) ]] && break
        unset dircolors
    done
    if [[ -z "$dircolors" ]]; then
        for dircolors in ~/.dir{_,}colors /etc/DIR{_,}COLORS; do
            [[ -r "$dircolors" ]] && break
        done
    fi
    #echo "$dircolors"
    test -r "$dircolors" && eval "$(dircolors -b $dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# set PATH so it includes user's private bin if it exists
if [ -d ~/.local/bin ] ; then
    # NOTE: Use absolute path to avoid security issues with relative paths
    export PATH="${HOME}/.local/bin:$PATH"
fi

# set PATH so it includes overlay bin if it exists
if [ -d ~/bin.d/overlay ] ; then
    # NOTE: Use absolute path to avoid security issues with relative paths
    export PATH="${HOME}/bin.d/overlay:$PATH"
fi

# set PATH so it includes host bin if it exists
if [ -d ~/bin.d/host."${HOSTNAME}" ] ; then
    # NOTE: Use absolute path to avoid security issues with relative paths
    export PATH="${HOME}/bin.d/host.${HOSTNAME}:$PATH"
fi

# export QT_SELECT=4

# Setup vimasaur (vim as our) editor
export SVN_EDITOR=vim
export EDITOR=vim
export VISUAL=vim

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bash configuration for this host
if [ -f ~/.bashrc.d/host."$HOSTNAME" ]; then
    . ~/.bashrc.d/host."$HOSTNAME" 
fi

# Auto-start ssh-agent
if [ -f ~/.ssh/agent.autostart ]; then
    . ~/.bashrc.d/ssh-agent
fi

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
