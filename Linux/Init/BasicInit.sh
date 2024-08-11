#!/bin/bash

# Enter your email
echo "Enter your email address: "
read -r EMAIL

export EMAIL

bash ./Basics/Aliases/Setup.sh
bash ./Basics/Git/Setup.sh
bash ./Basics/Docker/Setup.sh
bash ./Basics/Codium/Setup.sh
bash ./Basics/DevFolder/Setup.sh

echo "All tasks completed successfully. Please restart your terminal or run 'source ~/.bashrc' to apply changes."