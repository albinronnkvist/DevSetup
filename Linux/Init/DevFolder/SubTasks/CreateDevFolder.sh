#!/bin/bash

# Create a Dev folder (~/Documents/Dev) if it doesn't exist
DEV_DIR=~/Documents/Dev

if [ ! -d "$DEV_DIR" ]; then
    mkdir -p "$DEV_DIR"
    echo "Dev folder created at $DEV_DIR"
else
    echo "Dev folder already exists at $DEV_DIR"
fi