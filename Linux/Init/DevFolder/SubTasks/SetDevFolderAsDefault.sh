#!/bin/bash

# Set the Dev folder as the default when opening bash if not already set
BASHRC_FILE=~/.bashrc
DEFAULT_DIR="cd ~/Documents/Dev"

if ! grep -Fxq "$DEFAULT_DIR" "$BASHRC_FILE"; then
    echo "$DEFAULT_DIR" >> "$BASHRC_FILE"
    echo "Set Dev folder as default when opening bash"
else
    echo "Dev folder is already set as the default directory in bash"
fi