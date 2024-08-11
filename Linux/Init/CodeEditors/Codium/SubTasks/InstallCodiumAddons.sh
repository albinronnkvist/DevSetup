#!/bin/bash

# Install the specified VS Codium addons if not already installed
for extension in pkief.material-icon-theme christian-kohler.path-intellisense wayou.vscode-todo-highlight codezombiech.gitignore esbenp.prettier-vscode ms-azuretools.vscode-docker; do
    if ! codium --list-extensions | grep -q "$extension"; then
        codium --install-extension "$extension"
        echo "Installed $extension"
    else
        echo "$extension is already installed"
    fi
done

# Install the Codeium addon for VS Codium if not already installed
if ! codium --list-extensions | grep -q "Exafunction.codeium"; then
    codium --install-extension Exafunction.codeium
    echo "Codeium addon installed for VS Codium"
else
    echo "Codeium addon is already installed for VS Codium"
fi