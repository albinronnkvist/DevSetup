#!/bin/bash

# Enter your email
echo "Enter your email address: "
read -r EMAIL

export EMAIL

bash ./Aliases/Setup.sh
bash ./Git/Setup.sh
bash ./Docker/Setup.sh
bash ./CodeEditors/Codium/Setup.sh
bash ./DevFolder/Setup.sh

echo "All tasks completed successfully. Please restart your terminal or run 'source ~/.bashrc' to apply changes."