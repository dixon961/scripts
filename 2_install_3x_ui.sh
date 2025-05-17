#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo ./script.sh)"
   exit 1
fi

# Get the username of the non-root user who invoked sudo
TARGET_USER="${SUDO_USER:-$USER}"

# Variables
REPO_URL="https://github.com/MHSanaei/3x-ui"
CLONE_DIR="/home/$TARGET_USER/3x-ui/"

# Update system
apt update

# Install Git
apt install -y git
apt install -y curl

# Check if Docker is installed
if ! command docker -v &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
else
    echo "Docker is already installed. Skipping Docker installation."
fi

# Add the user to the docker group
echo "Adding user '$TARGET_USER' to the docker group..."
usermod -aG docker "$TARGET_USER"

echo "User '$TARGET_USER' added to docker group. They must log out and log back in for group changes to take effect."

# Clone repo
git clone "$REPO_URL" "$CLONE_DIR"

# Move to repo directory
cd "$CLONE_DIR"

# Run docker compose
docker compose up -d

echo "Done! Docker is running your containers."
