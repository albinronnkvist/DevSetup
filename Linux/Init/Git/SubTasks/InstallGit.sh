#!/bin/bash

# Install Git if it's not already installed
if ! command -v git &> /dev/null; then
    sudo apt update && sudo apt install -y git
    echo "Git installed"
else
    echo "Git is already installed"
fi
