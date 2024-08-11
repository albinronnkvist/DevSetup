#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up JavaScript..."

bash $SCRIPT_DIR/SubTasks/InstallNVM.sh
bash $SCRIPT_DIR/SubTasks/InstallCodiumAddons.sh