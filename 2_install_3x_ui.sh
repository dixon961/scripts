#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo ./script.sh)"
   exit 1
fi

# Variables
REPO_URL="https://github.com/your-username/your-repo.git"  # <-- change this!
CLONE_DIR="/opt/your-repo"  # where to clone

# Update system
apt update

# Install Git
apt install -y git

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Clone repo
git clone "$REPO_URL" "$CLONE_DIR"

# Move to repo directory
cd "$CLONE_DIR"

# Run docker compose
docker compose up -d

echo "Done! Docker is running your containers."
