#!/bin/bash

echo -e "\nSetting up Docker..."
bash ./SubTasks/InstallDocker.sh
bash ./SubTasks/RunDockerAsNonRoot.sh
bash ./SubTasks/EnableAndTestDocker.sh