#!/bin/bash

if ! command -v curl &> /dev/null; then
    sudo apt-get update
    sudo apt install -y curl
    echo "Curl installed"
else
    echo "Curl is already installed"
fi