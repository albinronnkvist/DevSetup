#!/bin/bash

echo -e "\nSetting up Codium..."
bash ./SubTasks/InstallCodium.sh
bash ./SubTasks/AliasCodeForCodium.sh
bash ./SubTasks/InstallCodiumAddons.sh