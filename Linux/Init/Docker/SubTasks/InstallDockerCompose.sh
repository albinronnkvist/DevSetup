#!/bin/bash

if ! docker compose version &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose plugin..."
    sudo apt install -y docker-compose-plugin
    echo "Docker Compose plugin installed successfully"
else
    echo "Docker Compose is already installed"
fi

docker compose version