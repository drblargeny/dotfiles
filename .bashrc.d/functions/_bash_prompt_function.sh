# Bash function for setting up a resonable terminal prompt
# Sets PS1 for normal prompt
# Sets TERM__COLORS with number of colors supported by terminal
function _bash_prompt_function() {
    PROMPT_TEXT="$*"

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
            # Current term supports a status line
            # Use terminfo to get the escapes to start and end the status line
            TERM__TITLE_TO=`tput tsl`
            TERM__TITLE_FROM=`tput fsl`
        else
            # Use term pattern detection
            _bash_prompt_function_term_title
        fi

    else
        # Can't read terminal via tput

# Another approach for determining terminals that support color
#use_color=true
#
## Set colorful PS1 only on colorful terminals.
## dircolors --print-database uses its own built-in database
## instead of using /etc/DIR_COLORS.  Try to use the external file
## first to take advantage of user additions.  Use internal bash
## globbing instead of external grep binary.
#safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
#match_lhs=""
#[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
#[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
#[[ -z ${match_lhs}    ]] \
#	&& type -P dircolors >/dev/null \
#	&& match_lhs=$(dircolors --print-database)
#[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true
#
#unset use_color safe_term match_lhs sh

        # Guess colors based on TERM type
        case "$TERM" in
            *-256color)
                # Assume 256 color xterm
                TERM__COLORS=256
                TERM__BLACK='\e[38;5;16m'
                TERM__BLUE='\e[38;5;105m'
                TERM__CYAN='\e[38;5;147m'
                TERM__GREEN='\e[38;5;34m'
                TERM__MAGENTA='\e[38;5;127m'
                TERM__RED='\e[38;5;124m'
                TERM__YELLOW='\e[38;5;142m'
                TERM__WHITE='\e[38;5;145m'
                TERM__RESET_ATTRIBUTES='\e(B\e[m'
                ;;
            xterm* | screen*)
                # Assume 8 colors
                TERM__COLORS=8
                TERM__BLACK='\e[30m'
                TERM__BLUE='\e[1m\e[34m'
                TERM__CYAN='\e[36m'
                TERM__GREEN='\e[32m'
                TERM__MAGENTA='\e[35m'
                TERM__RED='\e[31m'
                TERM__YELLOW='\e[33m'
                TERM__WHITE='\e[37m'
                TERM__RESET_ATTRIBUTES='\e[m'
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

        # Use term pattern detection
        _bash_prompt_function_term_title
    fi

    # Setup the primary prompt
    # \n[ISO 8601 short date/time] [# of jobs]
    PS1='\n\['"$TERM__RESET_ATTRIBUTES""$TERM__BLUE"'\]\D{%FT%T} \['"$TERM__RESET_ATTRIBUTES""$TERM__RED"'\]\j '

    # Include any additional information from arg 2
    if [[ -n "$PROMPT_TEXT" ]]; then
        PS1+='\['"$TERM__MAGENTA"'\]'"$PROMPT_TEXT"' '
    fi

    # Use different colors when running and the root user
    # [user]@[host]:
    if [[ ${EUID} == 0 ]]; then
        PS1+='\['"$TERM__RED"'\]\u@\h\['"$TERM__WHITE"'\]:'
    else
        PS1+='\['"$TERM__GREEN"'\]\u@\h\['"$TERM__WHITE"'\]:'
    fi
    # [working dir]\n$
    PS1+='\['"$TERM__YELLOW"'\]\w\['"$TERM__RESET_ATTRIBUTES"'\]\n\$ '

    # Setup display before each command
    # Output the timestamp of when we start the command
    PS0='\['"$TERM__RESET_ATTRIBUTES""$TERM__CYAN"'\]\D{%FT%T}'
    # along with the command and history numbers
    PS0+='\['"$TERM__GREEN"'\] \#\['"$TERM__YELLOW"'\] \!'
    # mark start of command output
    PS0+='\['"$TERM__MAGENTA"'\] >>>\['"$TERM__RESET_ATTRIBUTES"'\]\n'

    # Check if a title is defined and available
    if [[ -n "$TERM__TITLE_FROM" ]]; then
        # Prepend the escapes and desired info to the prompt
        PROMPT_COMMAND='echo -ne "${TERM__TITLE_TO}'
        if [[ -z "$SSH_CONNECTION" ]]; then
            # shell [~/working/dir]
            PROMPT_COMMAND+='${0##*/} '
        else
            # user@host:~/working/dir
            PROMPT_COMMAND+='${USER}@${HOSTNAME%%.*}:'
        fi
        PROMPT_COMMAND+='${PWD/#$HOME/\~}'
        PROMPT_COMMAND+='${TERM__TITLE_FROM}"'
    else
        unset PROMPT_COMMAND
    fi

    # Clean up variables so they don't polute the environment
    unset PROMPT_TEXT STATUS_LINE_TERM TERM__BLACK TERM__BLUE TERM__CYAN TERM__GREEN TERM__MAGENTA TERM__RED TERM__RESET_ATTRIBUTES TERM__WHITE TERM__YELLOW
}

function _bash_prompt_function_term_title() {
    case ${TERM} in
        # Change the window title of X terminals
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
            TERM__TITLE_TO='\e]0;'
            TERM__TITLE_FROM='\a'
            ;;
        # Change the screen application title
        screen*)
            TERM__TITLE_TO='\ek'
            # Alternatively, change the hardstatus
            #TERM__TITLE_TO='\e_'
            TERM__TITLE_FROM='\e\\'
            ;;
        *)
            # other terms do not support a status line
            unset TERM__TITLE_FROM TERM__TITLE_TO
            ;;
    esac
}
