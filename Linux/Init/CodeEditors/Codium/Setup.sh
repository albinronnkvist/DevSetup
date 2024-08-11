#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up Codium..."

bash $SCRIPT_DIR/SubTasks/InstallCodium.sh
bash $SCRIPT_DIR/SubTasks/AliasCodeForCodium.sh
bash $SCRIPT_DIR/SubTasks/InstallCodiumAddons.sh
