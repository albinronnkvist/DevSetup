#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up Java..."

bash $SCRIPT_DIR/SubTasks/InstallJDK.sh
echo
bash $SCRIPT_DIR/SubTasks/InstallCodiumAddons.sh
echo
bash $SCRIPT_DIR/SubTasks/InstallMaven.sh