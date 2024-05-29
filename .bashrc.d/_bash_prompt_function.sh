# Bash function for setting up a resonable terminal prompt
# Sets PS1 for normal prompt
# Sets SCREEN_TITLE for screen's title/status line
# Sets TERM__COLORS with number of colors supported by terminal
function _bash_prompt_function() {
    STATUS_LINE_TEXT="${1:-off}"
    PROMPT_TEXT="$2"

    # Check if tput is present to calculate values
    if command -v tput >/dev/null; then
        # Use tput to determine terminal parametes
        # Determine how many colors are supported
        TERM__COLORS=`tput colors`
        # Setup variables that contain control sequences for colors I like to use
        TERM__RESET_ATTRIBUTES=`tput sgr0`
        if (( "$TERM__COLORS" > 16 )); then
            # Support for more than 16 colors (e.g. xterm-256color, screen-256color)
            TERM__BLACK=`  tput setaf $((36*0 + 6*0 + 0 +16))`
            TERM__BLUE=`   tput setaf $((36*2 + 6*2 + 5 +16))`
            TERM__CYAN=`   tput setaf $((36*3 + 6*3 + 5 +16))`
            TERM__GREEN=`  tput setaf $((36*0 + 6*3 + 0 +16))`
            TERM__MAGENTA=`tput setaf $((36*3 + 6*0 + 3 +16))`
            TERM__RED=`    tput setaf $((36*3 + 6*0 + 0 +16))`
            TERM__YELLOW=` tput setaf $((36*3 + 6*3 + 0 +16))`
            TERM__WHITE=`  tput setaf $((36*3 + 6*3 + 3 +16))`
        elif [[ "$TERM__COLORS" > 8 ]]; then
            # Support for more than 8 colors
            TERM__BLACK=`  tput setaf  0`
            TERM__BLUE=`   tput setaf 12`
            TERM__CYAN=`   tput setaf  6`
            TERM__GREEN=`  tput setaf  2`
            TERM__MAGENTA=`tput setaf  5`
            TERM__RED=`    tput setaf  1`
            TERM__YELLOW=` tput setaf  3`
            TERM__WHITE=`  tput setaf  7`
        elif [[ "$TERM__COLORS" < 2 ]]; then
            # No support for colors
            TERM__BLACK=
            TERM__BLUE=
            TERM__CYAN=
            TERM__GREEN=
            TERM__MAGENTA=
            TERM__RED=
            TERM__YELLOW=
            TERM__WHITE=
        else
            # Support for 8 colors
            TERM__BLACK=`  tput setaf  0`
            TERM__BLUE=`   tput bold; tput setaf  4`
            TERM__CYAN=`   tput setaf  6`
            TERM__GREEN=`  tput setaf  2`
            TERM__MAGENTA=`tput setaf  5`
            TERM__RED=`    tput setaf  1`
            TERM__YELLOW=` tput setaf  3`
            TERM__WHITE=`  tput setaf  7`
        fi

        # Determine the status line terminal type
        if tput hs; then
            # Current term supports a status line, use as-is
            STATUS_LINE_TERM="$TERM"
        elif [[ "$TERM" =~ ^xterm.* ]]; then
            # xterms can usually use the window title, but they sometimes need a
            # special term type to recognize this. Test for this type and use it
            # when available
            infocmp 'xterm+sl' >/dev/null 2>&1 && STATUS_LINE_TERM='xterm+sl' || STATUS_LINE_TERM=
        elif [[ "$TERM" =~ ^screen.* ]]; then
            # screen terminals can use either the hardstatus line or the window title
            # but they need a special term type to recognize this
            STATUS_LINE_TERM='screen-s'
        else
            # other terms do not support a status line
            STATUS_LINE_TERM=
        fi

            # Check if a STATUS_LINE_TERM was set (i.e. status line is available)
        if [[ -n "$STATUS_LINE_TERM" ]]; then
            # This means we want to send information to the status line at each prompt,
            # which will make it easier/possible to find windows/sessions by name

            # Check to see if we're in a screen terminal
            if [[ "$STATUS_LINE_TERM" =~ ^screen.* ]]; then
                # In this case we actually want to write to the screen window title
                # rather than the status line. So use the screen-specific escapes
                TERM__STATUS_LINE_TO=`echo -ne '\ek'`
                TERM__STATUS_LINE_FROM=`echo -ne '\e\\'`'\'
            else
                # Use terminfo to get the escapes to start and end the status line
                TERM__STATUS_LINE_TO=`tput -T "$STATUS_LINE_TERM" tsl`
                TERM__STATUS_LINE_FROM=`tput -T "$STATUS_LINE_TERM" fsl`
            fi
        else
            TERM__STATUS_LINE_TO=
            TERM__STATUS_LINE_FROM=
        fi
    else
        # Can't read terminal via tput
        # Guess colors based on TERM type
        case "$TERM" in
            xterm-color)
                # Assume 8 colors
                TERM__COLORS=8
                TERM__BLACK='\[\033[30m'
                TERM__BLUE='\[\033[1m\[\033[34m'
                TERM__CYAN='\[\033[36m'
                TERM__GREEN='\[\033[32m'
                TERM__MAGENTA='\[\033[35m'
                TERM__RED='\[\033[31m'
                TERM__YELLOW='\[\033[33m'
                TERM__WHITE='\[\033[37m'
                TERM__RESET_ATTRIBUTES='\[\033[m'
                ;;
            *-256color)
                # Assume 256 color xterm
                TERM__COLORS=256
                TERM__BLACK='\[\033[38;5;16m'
                TERM__BLUE='\[\033[38;5;105m'
                TERM__CYAN='\[\033[38;5;147m'
                TERM__GREEN='\[\033[38;5;34m'
                TERM__MAGENTA='\[\033[38;5;127m'
                TERM__RED='\[\033[38;5;124m'
                TERM__YELLOW='\[\033[38;5;142m'
                TERM__WHITE='\[\033[38;5;145m'
                TERM__RESET_ATTRIBUTES='\[\033(B\[\033[m'
                ;;
            *)
                # default to no colors or status line
                TERM__COLORS=0
                TERM__BLACK=
                TERM__BLUE=
                TERM__CYAN=
                TERM__GREEN=
                TERM__MAGENTA=
                TERM__RED=
                TERM__YELLOW=
                TERM__WHITE=
                TERM__RESET_ATTRIBUTES=
                ;;
        esac
        # Assume no status line
        TERM__STATUS_LINE_TO=
        TERM__STATUS_LINE_FROM=
    fi

    # Setup the prompt
    # \n[ISO 8601 short date/time] [# of jobs]
    PS1='\n'"$TERM__RESET_ATTRIBUTES""$TERM__BLUE"'\D{%Y-%m-%dT%H:%M:%S} '"$TERM__RESET_ATTRIBUTES""$TERM__RED"'\j '

    # Include any additional information from arg 2
    if [[ -n "$PROMPT_TEXT" ]]; then
        PS1="$PS1""$TERM__RESET_ATTRIBUTES""$TERM__MAGENTA""$PROMPT_TEXT"' '
    fi

    # Use different colors when running and the root user
    # [user]@[host]:
    if [[ ${EUID} == 0 ]]; then
        PS1="$PS1""$TERM__RESET_ATTRIBUTES""$TERM__RED"'\u@\h'"$TERM__RESET_ATTRIBUTES""$TERM__WHITE"':'
    else
        PS1="$PS1""$TERM__RESET_ATTRIBUTES""$TERM__GREEN"'\u@\h'"$TERM__RESET_ATTRIBUTES""$TERM__WHITE"':'
    fi
    # [working dir]\n$
    PS1="$PS1""$TERM__RESET_ATTRIBUTES""$TERM__YELLOW"'\w'"$TERM__RESET_ATTRIBUTES""$TERM__WHITE"'\n\$ '

    # Check if a status line is defined and available
    if [[ "$STATUS_LINE_TEXT" != "off" && -n "$TERM__STATUS_LINE_FROM" ]]; then
        # Prepend the escapes and desired info to the prompt
        # bash [working dir]
        STATUS_LINE='\['"$TERM__STATUS_LINE_TO"
        if [[ -z "$STATUS_LINE_TEXT" ]]; then
            STATUS_LINE="$STATUS_LINE"'bash [\w]'
        elif [[ "$STATUS_LINE_TEXT" =~ \\w ]]; then
            STATUS_LINE="$STATUS_LINE""$STATUS_LINE_TEXT"
        else
            STATUS_LINE="$STATUS_LINE""$STATUS_LINE_TEXT"' [\w]'
        fi
        STATUS_LINE="$STATUS_LINE""$TERM__STATUS_LINE_FROM"'\]'
        PS1="$STATUS_LINE""$PS1"

        # Also create an escape sequence that can set the status line from the hardstatus line within screen
        export SCREEN_TITLE="$TERM__STATUS_LINE_TO"'screen %n %t%? [%h]%?'"$TERM__STATUS_LINE_FROM"
    else
        export SCREEN_TITLE=
    fi

    # Change the window title of X terminals
    case ${TERM} in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
            PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
            ;;
        screen*)
            PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
            ;;
        *)
            unset PROMPT_COMMAND
            ;;
    esac

    # Clean up variables so they don't polute the environment
    unset PROMPT_TEXT STATUS_LINE_TERM STATUS_LINE_TEXT TERM__BLACK TERM__BLUE TERM__CYAN TERM__GREEN TERM__MAGENTA TERM__RED TERM__RESET_ATTRIBUTES TERM__STATUS_LINE_FROM TERM__STATUS_LINE_TO TERM__WHITE TERM__YELLOW
}
