#!/bin/bash

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

if ! command -v virtualbox &> /dev/null; then
    echo "VirtualBox is not installed. Proceeding with update and installation."

    echo "Updating system..."
    sudo apt update
    check_success "System update"

    echo "Upgrading system..."
    sudo apt upgrade -y
    check_success "System upgrade"

    echo "Installing VirtualBox..."
    sudo apt install -y virtualbox
    check_success "VirtualBox installation"

    echo "VirtualBox installation completed successfully."
else
    echo "VirtualBox is already installed."
fi