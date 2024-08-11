#!/bin/bash

# Enable Docker and check status
sudo systemctl enable docker
sudo systemctl start docker
echo "Docker enabled and running"

# Test Docker installation
sudo docker run hello-world
echo "Docker test run completed"