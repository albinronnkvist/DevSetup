#!/bin/bash

# Enter your email
echo "Enter your email address: "
read -r EMAIL

export EMAIL

bash ./Aliases/Setup.sh
bash ./Git/Setup.sh
bash ./Docker/Setup.sh
bash ./CodeEditors/Codium/Setup.sh

# Other
bash ./Other/InstallClamAV.sh

# Run DevFolder last
bash ./DevFolder/Setup.sh

echo "All basic init tasks completed successfully."