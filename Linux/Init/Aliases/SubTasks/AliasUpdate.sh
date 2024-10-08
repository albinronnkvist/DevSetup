#!/bin/bash

BASHRC_FILE=~/.bashrc
ALIAS_COMMAND="alias update='sudo apt update && sudo apt upgrade && sudo apt dist-upgrade'"

if ! grep -Fxq "$ALIAS_COMMAND" "$BASHRC_FILE"; then
    if [ -n "$(tail -c1 "$BASHRC_FILE")" ]; then
        echo >> "$BASHRC_FILE"
    fi

    echo "$ALIAS_COMMAND" >> "$BASHRC_FILE"
    echo "'update' alias set in bash"
else
    echo "'update' alias is already set"
fi