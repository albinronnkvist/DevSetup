#!/bin/bash

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

if ! command -v libreoffice &> /dev/null; then
    echo "Installing LibreOffice..."
    sudo apt update && sudo apt install -y libreoffice
    check_success "LibreOffice installation"
else
    echo "LibreOffice is already installed"
fi
