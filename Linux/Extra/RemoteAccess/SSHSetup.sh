#!/bin/bash

# Check for errors
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

# User input
read -p "Enter the remote username: " REMOTE_USER
read -p "Enter the remote host (e.g., IP address or domain): " REMOTE_HOST
read -p "Enter the SSH port (default is 22): " SSH_PORT
SSH_PORT=${SSH_PORT:-22}
read -p "Enter a name for the SSH key (default is id_rsa): " SSH_KEY_NAME
SSH_KEY_NAME=${SSH_KEY_NAME:-id_rsa}
read -s -p "Enter your email for SSH key generation: " EMAIL
echo

# Generate SSH key
SSH_KEY_PATH="$HOME/.ssh/$SSH_KEY_NAME"
if [ -f "$SSH_KEY_PATH" ]; then
    echo "SSH key $SSH_KEY_PATH already exists. Skipping key generation."
else
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$SSH_KEY_PATH" -N ""
    check_success "SSH key generation"
fi

# Remove old host key to prevent issues with changed keys
echo "Checking for existing host key..."
ssh-keygen -R "[$REMOTE_HOST]:$SSH_PORT" >/dev/null 2>&1
check_success "Removing old host key (if any)"

# Copy SSH key to remote host
echo "Copying SSH key to the remote host..."
ssh-copy-id -i "$SSH_KEY_PATH" -p $SSH_PORT "$REMOTE_USER@$REMOTE_HOST"
check_success "Copying SSH key to remote host"

# Configure SSH client
echo "Configuring SSH client..."
SSH_CONFIG="$HOME/.ssh/config"
if grep -q "Host $REMOTE_HOST" "$SSH_CONFIG"; then
    echo "SSH configuration for $REMOTE_HOST already exists. Skipping configuration."
else
    {
        echo "Host $REMOTE_HOST"
        echo "  HostName $REMOTE_HOST"
        echo "  User $REMOTE_USER"
        echo "  Port $SSH_PORT"
        echo "  IdentityFile $SSH_KEY_PATH"
    } >> "$SSH_CONFIG"
    check_success "SSH client configuration"
fi

echo "Setup complete! You can now SSH into the remote machine using:"
echo "ssh $REMOTE_HOST"

# Optional
echo
echo "#### (Optional) - Secure SSH Server Setup ####"
echo "Run these commands to improve the security of the SSH server:"
echo "1. Open config: 'sudo nano /etc/ssh/sshd_config'"
echo "2. Disable root login in the file: 'PermitRootLogin no'"
echo "3. Disable password authentication in the file: 'PasswordAuthentication no'"
echo "4. Restart SSH server: 'sudo systemctl restart ssh'"