#!/bin/bash

# Install GitHub CLI if it's not already installed
if ! command -v gh &> /dev/null; then
    sudo apt update && sudo apt install -y gh
    gh auth login
    echo "GitHub CLI installed"
else
    echo "GitHub CLI is already installed"
fi