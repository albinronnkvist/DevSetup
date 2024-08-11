#!/bin/bash

# Set 'code' command as VS Codium (alias code='codium') if not already set
BASHRC_FILE=~/.bashrc
if ! grep -Fxq "alias code='codium'" "$BASHRC_FILE"; then
    echo "alias code='codium'" >> "$BASHRC_FILE"
    echo "'code' alias set for VS Codium"
else
    echo "'code' alias is already set"
fi