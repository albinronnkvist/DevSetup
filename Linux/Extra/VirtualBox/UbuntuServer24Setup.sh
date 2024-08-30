#!/bin/bash

# Ensure that you have the Ubuntu Server ISO file downloaded and accessible in the ISO_PATH specified below
# Download: https://ubuntu.com/download/server

check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

# Dependencies
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
bash $SCRIPT_DIR/InstallVirtualBox.sh
bash $SCRIPT_DIR/InstallGenIsoImage.sh

# User input
read -s -p "Enter your email: " EMAIL
echo

read -s -p "Enter the username for the new VM user: " USER_NAME
echo

read -s -p "Enter the password for the new VM user: " USER_PASSWORD
echo
HASHED_PASSWORD=$(echo -n "$USER_PASSWORD" | openssl passwd -6 -stdin)

# Paths and settings
VM_NAME="UbuntuServer24"
ISO_PATH="$HOME/Documents/VM/UbuntuServer24.iso"
CUSTOM_ISO_PATH="$HOME/Documents/VM/UbuntuServer24-Autoinstall.iso"
VBOX_DISK_PATH="$HOME/Documents/VM/$VM_NAME/$VM_NAME.vdi"
WORK_DIR="$HOME/Documents/VM/iso-workdir"
DISK_SIZE="20480"  # (20GB)
RAM_SIZE="2048"  # (2GB)
VRAM_SIZE="16"  # (16MB)
SSH_PORT="2222"

# Create a custom ISO with the autoinstall configuration
create_custom_iso() {
    echo "Creating custom ISO with autoinstall configuration..."
    
    # Prepare the working directory
    mkdir -p $WORK_DIR
    cp "$ISO_PATH" $WORK_DIR/original.iso
    check_success "Copying original ISO"

    # Mount the ISO to extract it
    mkdir -p $WORK_DIR/mount
    sudo mount -o loop $WORK_DIR/original.iso $WORK_DIR/mount
    check_success "Mounting ISO"

    # Copy the contents to a working directory with correct permissions
    mkdir -p $WORK_DIR/extract
    sudo rsync -a $WORK_DIR/mount/ $WORK_DIR/extract/
    sudo umount $WORK_DIR/mount

    # Create the autoinstall configuration in /tmp and move it to the extracted ISO directory
    AUTOINSTALL_CONFIG="/tmp/autoinstall.yaml"
    cat > $AUTOINSTALL_CONFIG <<EOF
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: ubuntu-server
    username: "$USER_NAME"
    password: "$HASHED_PASSWORD"
  keyboard:
    layout: se
    variant: ''
  locale: en_US.UTF-8
  timezone: UTC
  network:
    network:
      version: 2
      ethernets:
        enp0s3:
          dhcp4: true
  storage:
    layout:
      name: lvm
  packages:
    - openssh-server
  late-commands:
    - curtin in-target --target=/target -- systemctl enable ssh
    - curtin in-target --target=/target -- ufw allow ssh
EOF

    sudo cp $AUTOINSTALL_CONFIG $WORK_DIR/extract/
    sudo chown $USER:$USER $WORK_DIR/extract/autoinstall.yaml

    # Repack the ISO using the correct bootloader settings
    cd $WORK_DIR/extract

    if [ -d "isolinux" ]; then
        sudo sed -i 's/^timeout=[0-9]*$/timeout=1/' $WORK_DIR/extract/isolinux/isolinux.cfg
        sudo mkisofs -D -r -V "Ubuntu Server Autoinstall" -cache-inodes -J -l \
            -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
            -boot-info-table -o $CUSTOM_ISO_PATH .
    elif [ -d "boot/grub" ]; then
        sudo sed -i 's/^\s*set timeout=[0-9]*$/set timeout=1/' $WORK_DIR/extract/boot/grub/grub.cfg
        sudo mkisofs -D -r -V "Ubuntu Server Autoinstall" -cache-inodes -J -l \
            -b boot/grub/i386-pc/eltorito.img -c boot.catalog -no-emul-boot -boot-load-size 4 \
            -boot-info-table -o $CUSTOM_ISO_PATH .
    else
        echo "Error: No bootloader directory found (isolinux or grub). Exiting."
        exit 1
    fi

    check_success "Creating custom ISO"

    echo "Custom ISO created at $CUSTOM_ISO_PATH"
}

# Check if the custom ISO already exists, if not, create it
if [ ! -f "$CUSTOM_ISO_PATH" ]; then
    create_custom_iso
else
    echo "Custom ISO already exists at $CUSTOM_ISO_PATH."
fi

# Create the VM
if vboxmanage list vms | grep -q "\"$VM_NAME\""; then
    echo "VM $VM_NAME already exists. Skipping creation."
else
    echo "Creating new VirtualBox VM for Ubuntu Server..."
    vboxmanage createvm --name "$VM_NAME" --ostype "Ubuntu_64" --register
    check_success "VM creation"
fi

echo "Configuring VM settings..."
vboxmanage modifyvm "$VM_NAME" --memory "$RAM_SIZE" --vram "$VRAM_SIZE" --cpus 2 --ioapic on --boot1 dvd --nic1 nat
check_success "VM configuration"

# Create and attach the virtual hard disk
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

# Attach the custom ISO to the VM
if ! vboxmanage showvminfo "$VM_NAME" | grep -q "$CUSTOM_ISO_PATH"; then
    echo "Attaching custom Ubuntu Server ISO to VM..."
    vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --add ide
    vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$CUSTOM_ISO_PATH"
    check_success "Attach ISO"
else
    echo "Custom Ubuntu Server ISO is already attached."
fi

# Set up port forwarding for SSH
echo "Setting up port forwarding for SSH..."
vboxmanage modifyvm "$VM_NAME" --natpf1 "ssh,tcp,,$SSH_PORT,,22"
check_success "Port forwarding setup"

echo "Starting VM..."
vboxmanage startvm "$VM_NAME" --type gui
check_success "Starting VM"

# Manual prompts (could automate this, view: https://canonical-subiquity.readthedocs-hosted.com/en/latest/explanation/zero-touch-autoinstall.html)
echo
echo "#### MANUAL STEPS ####"
echo "Manual steps to complete the setup in the VM:"
echo "1. When prompted with 'Continue with autoinstall? (yes|no)': Enter 'yes' and wait for the installation to complete."
echo "2. When with 'ubuntu-server lgin': Enter the username and password that you set in the previous steps."
echo
read -p "Press Enter to continue once the setup is complete..."

echo "Stopping VM..."
vboxmanage controlvm "$VM_NAME" poweroff
check_success "Stopping VM"

echo "Starting VM in headless mode..."
vboxmanage startvm "$VM_NAME" --type headless
check_success "Starting VM"

sleep 5

# SSH into the VM
echo "Connecting to the VM via SSH..."
ssh -p $SSH_PORT $USER_NAME@localhost

# TODO:
# - Generate & Add SSH keys to server
#   - ssh-keygen -t rsa -b 4096 -C "$EMAIL"
#   - ssh-copy-id $USER_NAME@localhost
# - Login
#   - ssh -p $SSH_PORT $USER_NAME@localhost
# - Configure SSH Server (no password auth, no root access, etc.)
#   - exit
# - Configure SSH Client
#   - 
# - Login with alias
#   - ssh UbuntuServerVM