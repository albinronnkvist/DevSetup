#!/bin/bash

# Install Docker if it's not already installed
if ! command -v docker &> /dev/null; then
    sudo apt update && sudo apt install -y docker.io
    echo "Docker installed"
else
    echo "Docker is already installed"
fi
