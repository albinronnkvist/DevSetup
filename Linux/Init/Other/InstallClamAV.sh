#!/bin/bash

# Install ClamAV, and update its virus database

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

echo "Installing ClamAV and ClamAV Daemon..."
sudo apt install -y clamav clamav-daemon
check_success "ClamAV installation"

echo "Verifying ClamAV installation..."
clamscan --version
check_success "ClamAV version check"

echo "Stopping clamav-freshclam service..."
sudo systemctl stop clamav-freshclam
check_success "Stopping clamav-freshclam service"

echo "Updating ClamAV virus database..."
sudo freshclam
check_success "Updating ClamAV virus database"

echo "Enabling and starting clamav-freshclam service..."
sudo systemctl enable clamav-freshclam --now
check_success "Enabling and starting clamav-freshclam service"

echo "ClamAV installation and setup complete."