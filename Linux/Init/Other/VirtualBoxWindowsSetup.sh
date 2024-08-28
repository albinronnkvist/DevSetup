#!/bin/bash

# Ensure that you have the Windows 11 ISO file downloaded and accessible in the correct folder (see ISO_PATH further down)
# Download: https://www.microsoft.com/software-download/windows11
# Minimum requirements: https://www.microsoft.com/en-us/windows/windows-11-specifications

# Ensure that you have VBox GuestAdditions ISO file downloaded and accessible in the correct folder (see GUEST_ADDITIONS_PATH further down)
# Download: https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
check_success "System update"

echo "Installing VirtualBox..."
sudo apt install -y virtualbox
check_success "VirtualBox installation"

VM_NAME="Windows11"
ISO_PATH="$HOME/Documents/VM/Windows11.iso"
GUEST_ADDITIONS_PATH="$HOME/Documents/VM/VBoxGuestAdditions.iso"
VBOX_DISK_PATH="$HOME/Documents/VM/$VM_NAME/$VM_NAME.vdi"
DISK_SIZE="65000"  # (65GB)
RAM_SIZE="4096"  # (4GB)
VRAM_SIZE="256"  # (256MB)

if vboxmanage list vms | grep -q "\"$VM_NAME\""; then
    echo "VM $VM_NAME already exists. Skipping creation."
else
    echo "Creating new VirtualBox VM for Windows 11..."
    vboxmanage createvm --name "$VM_NAME" --ostype "Windows11_64" --register
    check_success "VM creation"
fi

echo "Configuring VM settings..."
vboxmanage modifyvm "$VM_NAME" --memory "$RAM_SIZE" --vram "$VRAM_SIZE" --cpus 2 --ioapic on --graphicscontroller vboxsvga --accelerate3d on --boot1 dvd --nic1 nat
vboxmanage setextradata "$VM_NAME" "CustomVideoMode1" "1920x1080x32"
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
    echo "Attaching Windows 11 ISO to VM..."
    vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --add ide
    vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"
    vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$GUEST_ADDITIONS_PATH"
    check_success "Attach ISO"
else
    echo "Windows 11 ISO is already attached."
fi

echo "Disabling the network interface in the VM temporarily to be able to setup local windows user..."
vboxmanage modifyvm "$VM_NAME" --nic1 none
check_success "Disable network interface"

echo "Starting VM..."
vboxmanage startvm "$VM_NAME" --type gui
check_success "Starting VM"

# Manual intervention
echo
echo "#### WINDOWS MANUAL SETUP ####"
echo "Manual steps to complete the setup in the Windows VM (press 'right-Ctrl + C' to exit the VM window if you're stuck in fullscreen):"
echo "1. Wait for the VM window to open and press any key when prompted to boot from media."
echo "2. Go through the manual Windows setup:"
echo "  - Select the 'I don't have internet' and 'Continue with limited setup' options to use a local account instead of a Microsoft account."
echo "3. Install VBoxWindowsAdditions:"
echo "  - Open a new Powershell terminal as admin."
echo "  - Enter this one-liner (the file path may be different): "
echo "    Start-Process -FilePath "E:\VBoxWindowsAdditions.exe" -ArgumentList "/S" -NoNewWindow -Wait"
echo "  - Wait for it to complete."
echo
read -p "Press Enter to continue once the setup is complete..."

echo "Stopping VM..."
vboxmanage controlvm "$VM_NAME" poweroff
check_success "Stopping VM"

echo "Re-enabling the network interface in the VM..."
sleep 5
vboxmanage modifyvm "$VM_NAME" --nic1 nat
check_success "Enable network interface"

echo "Starting VM..."
vboxmanage startvm "$VM_NAME" --type gui
check_success "Starting VM"

echo "Windows 11 VM setup complete."
echo "Adjust resolution if needed in Windows settings and/or VirtualBox settings."