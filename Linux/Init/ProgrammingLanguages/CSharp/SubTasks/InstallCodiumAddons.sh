#!/bin/bash

# Install VS Codium C# specific addons if not already installed
for extension in muhammad-sammy.csharp jsw.csharpextensions; do
    if ! codium --list-extensions | grep -q "$extension"; then
        codium --install-extension "$extension"
        echo "Installed $extension"
    else
        echo "$extension is already installed"
    fi
done