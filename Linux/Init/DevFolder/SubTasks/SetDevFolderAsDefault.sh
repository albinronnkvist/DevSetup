#!/bin/bash

# TODO: modify the script so that it opens the ~/Documents/Dev folder by default only if the user is not already in a subdirectory of Dev.
# Set the Dev folder as the default when opening bash if not already set
BASHRC_FILE=~/.bashrc
DEFAULT_DIR="cd ~/Documents/Dev"

if ! grep -Fxq "$DEFAULT_DIR" "$BASHRC_FILE"; then
    if [ -n "$(tail -c1 "$BASHRC_FILE")" ]; then
        echo >> "$BASHRC_FILE"
    fi

    echo "$DEFAULT_DIR" >> "$BASHRC_FILE"
    echo "Set Dev folder as default when opening bash"
else
    echo "Dev folder is already set as the default directory in bash"
fi