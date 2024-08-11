#!/bin/bash

# Install VS Codium JavaScript specific addons if not already installed
if ! codium --list-extensions | grep -q "dbaeumer.vscode-eslint"; then
    codium --install-extension dbaeumer.vscode-eslint
    echo "JavaScript VS Codium addons installed"
else
    echo "JavaScript VS Codium addons are already installed"
fi