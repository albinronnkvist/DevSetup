#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up Docker..."

bash $SCRIPT_DIR/SubTasks/InstallDocker.sh
bash $SCRIPT_DIR/SubTasks/RunDockerAsNonRoot.sh
bash $SCRIPT_DIR/SubTasks/EnableAndTestDocker.sh
bash $SCRIPT_DIR/SubTasks/InstallDockerCompose.sh