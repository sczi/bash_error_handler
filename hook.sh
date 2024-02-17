#!/bin/bash

BOLD_RED="\033[1;31m"
RESET_FORMATTING="\033[00m"

error_msg () {
    LAST_EXIT_STATUS=$?
    LAST_COMMAND=${LAST_COMMAND:-$BASH_COMMAND}
    echo -e "
${BOLD_RED}Error, exited with status $LAST_EXIT_STATUS when running:
$RESET_FORMATTING$LAST_COMMAND
"
}

error_hook () {
    error_msg
    PS3="Choose a restart: "
    select restart in "Retry" "Edit command and retry" "Spawn shell" "Continue (ignoring error)" "Abort (exit shell)"
    do
        REPLY=
        echo
        case $restart in
        "Retry")
            eval $LAST_COMMAND && break || error_msg;;
        "Edit command and retry")
            local tempfile=$(mktemp)
            echo "$LAST_COMMAND" > "$tempfile"
            if ${EDITOR:=nano} "$tempfile"
            then
                LAST_COMMAND=$(cat "$tempfile")
                rm "$tempfile"
                eval $LAST_COMMAND && break || error_msg
            fi;;
        "Spawn shell")
            # spawn subshell with copies of our variables,
            # excluding special read only ones like PPID
            (export BASHOPTS SHELLOPTS && bash --rcfile <(declare -p | grep -v '^declare \S*r'; declare -f))
            echo
            echo "$LAST_COMMAND";;
        "Continue (ignoring error)")
            break;;
        "Abort (exit shell)")
            exit "$LAST_EXIT_STATUS";;
        *) echo "Invalid option";;
        esac
    done
    unset LAST_COMMAND LAST_EXIT_STATUS
}

# only activate when scripts are run in an interactive shell
tty -s && trap error_hook ERR
