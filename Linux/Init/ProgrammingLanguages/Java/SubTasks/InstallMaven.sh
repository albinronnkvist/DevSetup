#!/bin/bash

if ! command -v mvn &> /dev/null; then
    sudo apt update && sudo apt install maven -y
    echo "Maven installed"
else
    echo "Maven is already installed"
fi