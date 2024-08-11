#!/bin/bash

# Install Curl
bash ../../Other/InstallCurl.sh

# Default NVM version if not specified
DEFAULT_NVM_VERSION="v0.39.1"

# Use the specified version if provided, otherwise use the default version
NVM_VERSION=${1:-$DEFAULT_NVM_VERSION}

# Install NVM if it's not already installed
if ! command -v nvm &> /dev/null; then
    sudo apt-get update
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
    source ~/.bashrc
    echo "NVM version $NVM_VERSION installed"
else
    echo "NVM version $NVM_VERSION is already installed"
fi