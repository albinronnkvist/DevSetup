#!/bin/bash

DEFAULT_JDK_VERSION="17"
JDK_VERSION=${1:-$DEFAULT_JDK_VERSION}

install_jdk() {
    sudo apt update && sudo apt install -y openjdk-$JDK_VERSION-jdk
    echo "JDK $JDK_VERSION installed"
}

if ! command -v java &> /dev/null; then
    install_jdk
else
    INSTALLED_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F '.' '{print $1}')
    if [ "$INSTALLED_VERSION" == "$JDK_VERSION" ]; then
        echo "JDK $JDK_VERSION is already installed"
    else
        echo "Different JDK version ($INSTALLED_VERSION) is installed. Installing JDK $JDK_VERSION."
        install_jdk
    fi
fi

echo
echo "Select JDK version to use: "
sudo update-alternatives --config java

echo
echo "JDK version currently in use: "
java -version