#!/bin/bash

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

if ! command -v genisoimage &> /dev/null; then
    sudo apt update
    sudo apt install -y genisoimage

    check_success "GenIsoImage installation"
    echo "GenIsoImage installation completed successfully."
else
    echo "GenIsoImage is already installed."
fi