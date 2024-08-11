#!/bin/bash

# Check for existing SSH keys
if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "Existing SSH key pair found."
else
    echo -e "\nNo existing SSH key pair found. Generating a new SSH key pair..."
    echo -e "\nWhen you're prompted to "Enter a file in which to save the key", you can press Enter to accept the default file location."
    
    # Generate a new SSH key pair
    ssh-keygen -t ed25519 -C "$EMAIL"
    
    echo "N\new SSH key pair generated."

    # Start the SSH agent and add the SSH key
    echo -e "\nAdding SSH key to the SSH agent..."
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo -e "\nSSH key added to the SSH agent."
fi

# Display the SSH public key
echo -e "\nYour SSH public key is:"
cat ~/.ssh/id_ed25519.pub

# Instructions for adding the SSH key to GitHub
echo -e "\nTo add your SSH key to GitHub:"
echo "1. Go to https://github.com/settings/keys"
echo "2. Click on 'New SSH key'"
echo "3. Paste your SSH key into the 'Key' field and give it a title"
echo "4. Click 'Add SSH key'"

# Test the SSH connection to GitHub
echo -e "\nTesting SSH connection to GitHub..."
ssh -T git@github.com
