#!/bin/bash

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
check_success "System update"

echo "Installing LibreOffice..."
sudo apt install -y libreoffice
check_success "LibreOffice installation"
