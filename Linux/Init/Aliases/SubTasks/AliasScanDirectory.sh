#!/bin/bash

BASHRC_FILE=~/.bashrc
ALIAS_COMMAND="alias scandir='clamscan -r ./'"

if ! grep -Fxq "$ALIAS_COMMAND" "$BASHRC_FILE"; then
    if [ -n "$(tail -c1 "$BASHRC_FILE")" ]; then
        echo >> "$BASHRC_FILE"
    fi

    echo "$ALIAS_COMMAND" >> "$BASHRC_FILE"
    echo "'scandir' alias set in bash"
else
    echo "'scandir' alias is already set"
fi