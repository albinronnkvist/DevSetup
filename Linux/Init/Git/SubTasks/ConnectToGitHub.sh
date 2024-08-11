#!/bin/bash

# Check for existing SSH keys
if [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; then
    echo "Existing SSH key pair found:"
    ls -al ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
else
    echo "No existing SSH key pair found. Generating a new SSH key pair..."
    
    # Generate a new SSH key pair
    ssh-keygen -t rsa -b 4096 -C "$EMAIL"
    
    echo "New SSH key pair generated."
fi

# Start the SSH agent and add the SSH key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "SSH key added to the SSH agent."

# Display the SSH public key
echo "Your SSH public key is:"
cat ~/.ssh/id_rsa.pub

echo "Please copy the above SSH public key and add it to your GitHub account."

# Instructions for adding the SSH key to GitHub
echo "To add your SSH key to GitHub:"
echo "1. Go to https://github.com/settings/keys"
echo "2. Click on 'New SSH key'"
echo "3. Paste your SSH key into the 'Key' field and give it a title"
echo "4. Click 'Add SSH key'"

# Test the SSH connection to GitHub
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com

echo "If you see a message like 'Hi username! You've successfully authenticated,' then everything is set up correctly."
