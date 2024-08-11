#!/bin/bash

# Allow running Docker as non-root user if not already configured
if ! groups $USER | grep -q "docker"; then
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    echo "Docker configured to run as non-root user"
else
    echo "Docker is already configured to run as non-root user"
fi