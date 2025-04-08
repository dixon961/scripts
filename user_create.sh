#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Ask for username and password
read -p "Enter new username: " username
read -s -p "Enter password for $username: " password
echo

# Create user
useradd -m -s /bin/bash "$username"

# Set password
echo "$username:$password" | chpasswd

# Add user to sudo group
usermod -aG sudo "$username"

echo "User '$username' created and added to sudo group."
