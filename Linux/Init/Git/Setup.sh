#!/bin/bash

echo -e "\nSetting up Git..."
bash ./SubTasks/InstallGit.sh
bash ./SubTasks/AliasGForGit.sh
bash ./SubTasks/ConfigureGitConfig.sh
bash ./SubTasks/ConnectToGitHub.sh