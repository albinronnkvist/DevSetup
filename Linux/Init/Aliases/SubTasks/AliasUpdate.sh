#!/bin/bash

BASHRC_FILE=~/.bashrc

if ! grep -Fxq "alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'" "$BASHRC_FILE"; then
    echo "alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'" >> "$BASHRC_FILE"
    echo "'update' alias set in bash"
else
    echo "'update' alias is already set"
fi