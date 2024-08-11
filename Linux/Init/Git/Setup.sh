#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo -e "\nSetting up Git..."

bash $SCRIPT_DIR/SubTasks/InstallGit.sh
bash $SCRIPT_DIR/SubTasks/AliasGForGit.sh
bash $SCRIPT_DIR/SubTasks/ConfigureGitConfig.sh
bash $SCRIPT_DIR/SubTasks/ConnectToGitHub.sh