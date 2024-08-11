#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up Dev folder..."

bash $SCRIPT_DIR/SubTasks/CreateDevFolder.sh
bash $SCRIPT_DIR/SubTasks/SetDevFolderAsDefault.sh