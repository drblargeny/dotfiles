# Alias definitions.

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

[[ "$TERM__COLORS" > 0 ]] && color_auto='--color=auto' || color_auto=
alias grep="grep $color_auto"                # show differences in colour
alias egrep="egrep $color_auto"              # show differences in colour
alias fgrep="fgrep $color_auto"              # show differences in colour

# some more ls aliases
alias ll="ls $color_auto -alF --quoting-style=escape"     # long list
alias la="ls $color_auto -A"                              # all but . and ..
alias l="ls $color_auto -CF"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
# alias less='less -r'                          # raw control characters
# alias more=less
# alias np='nano -w PKGBUILD'
# alias whence='type -a'                        # where, of a sort

unset color_auto

# rsync display options
alias rsync='rsync -z --progress'


# Load Python aliases if python command exists
[ -n "$(command -v python)" ] && . ~/.bashrc.d/python-aliases

# Alias for curl to work around the OpenSSL 3 change to legacy renegotiation
alias curl.='OPENSSL_CONF=~/.openssl-UnsafeLegacyRengotiation.conf curl'
alias openssl.='OPENSSL_CONF=~/.openssl-UnsafeLegacyRengotiation.conf openssl'

# Alias for git-dir*.sh scripts to save a couple keystrokes
alias git.=git-dir.sh
alias git.branch=git-dir-branch.sh

# Alias for wmvn.sh script to save a couple of keystrokes
alias mvn.=wmvn.sh

