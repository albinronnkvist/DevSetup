#!/bin/bash

echo "Installing VS Codium Java specific addons..."
for extension in vscjava.vscode-java-pack; do
    if ! codium --list-extensions | grep -q "$extension"; then
        codium --install-extension "$extension"
        echo "Installed $extension"
    else
        echo "$extension is already installed"
    fi
done