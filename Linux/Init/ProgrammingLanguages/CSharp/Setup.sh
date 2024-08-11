#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up C#..."

bash $SCRIPT_DIR/SubTasks/InstallSDK.sh
bash $SCRIPT_DIR/SubTasks/InstallCodiumAddons.sh