#!/bin/bash

# Set 'g' as an alias for git in bash if not already set
BASHRC_FILE=~/.bashrc
if ! grep -Fxq "alias g='git'" "$BASHRC_FILE"; then
    if [ -n "$(tail -c1 "$BASHRC_FILE")" ]; then
        echo >> "$BASHRC_FILE"
    fi
    
    echo "alias g='git'" >> "$BASHRC_FILE"
    echo "'g' alias for git set in bash"
else
    echo "'g' alias for git is already set"
fi