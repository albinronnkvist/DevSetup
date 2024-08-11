#!/bin/bash

# Default NVM version if not specified
DEFAULT_DOTNET_VERSION="8.0"

# Use the specified version if provided, otherwise use the default version
DOTNET_VERSION=${1:-$DEFAULT_DOTNET_VERSION}

# Install .NET SDK if it's not already installed
# https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install?tabs=dotnet8&pivots=os-linux-ubuntu-2404
if ! command -v dotnet &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y dotnet-sdk-$DOTNET_VERSION
    echo ".NET SDK $DOTNET_VERSION installed"
else
    echo ".NET SDK $DOTNET_VERSION is already installed"
fi