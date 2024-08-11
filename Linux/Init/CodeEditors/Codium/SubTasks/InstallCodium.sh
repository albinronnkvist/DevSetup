#!/bin/bash

# Install VS Codium if it's not already installed
if ! command -v codium &> /dev/null; then
    sudo apt update && sudo apt install -y codium
    echo "VS Codium installed"
else
    echo "VS Codium is already installed"
fi
