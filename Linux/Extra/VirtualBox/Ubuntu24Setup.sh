#!/bin/bash

# Ensure that you have the Ubuntu ISO file downloaded and accessible in the correct folder (see ISO_PATH further down)
# Download: https://ubuntu.com/download/desktop
# Minimum requirements: https://help.ubuntu.com/community/Installation/SystemRequirements

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
bash $SCRIPT_DIR/InstallVirtualBox.sh

VM_NAME="Ubuntu24"
ISO_PATH="$HOME/Documents/VM/Ubuntu24.iso"
VBOX_DISK_PATH="$HOME/Documents/VM/$VM_NAME/$VM_NAME.vdi"
DISK_SIZE="65000"  # (65GB)
RAM_SIZE="4096"  # (4GB)
VRAM_SIZE="256"  # (256MB)

if vboxmanage list vms | grep -q "\"$VM_NAME\""; then
    echo "VM $VM_NAME already exists. Skipping creation."
else
    echo "Creating new VirtualBox VM for Ubuntu..."
    vboxmanage createvm --name "$VM_NAME" --ostype "Ubuntu_64" --register
    check_success "VM creation"
fi

echo "Configuring VM settings..."
vboxmanage modifyvm "$VM_NAME" --memory "$RAM_SIZE" --vram "$VRAM_SIZE" --cpus 2 --ioapic on --graphicscontroller vboxsvga --boot1 dvd --nic1 nat
check_success "VM configuration"

if [ -f "$VBOX_DISK_PATH" ]; then
    echo "Virtual hard disk already exists at $VBOX_DISK_PATH. Skipping disk creation."
else
    echo "Creating virtual hard disk..."
    mkdir -p "$(dirname "$VBOX_DISK_PATH")"  # Create the directory if it doesn't exist
    vboxmanage createhd --filename "$VBOX_DISK_PATH" --size "$DISK_SIZE"
    check_success "Virtual hard disk creation"
fi

if ! vboxmanage showvminfo "$VM_NAME" | grep -q "$VBOX_DISK_PATH"; then
    echo "Attaching virtual hard disk to VM..."
    vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
    vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VBOX_DISK_PATH"
    check_success "Attach hard disk"
else
    echo "Virtual hard disk is already attached."
fi

if ! vboxmanage showvminfo "$VM_NAME" | grep -q "$ISO_PATH"; then
    echo "Attaching Ubuntu ISO to VM..."
    vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --add ide
    vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"
    check_success "Attach ISO"
else
    echo "Ubuntu ISO is already attached."
fi

echo "Starting VM..."
vboxmanage startvm "$VM_NAME" --type gui
check_success "Starting VM"

echo "Follow the instructions inside the VM to complete the setup!"
