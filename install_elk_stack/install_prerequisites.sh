#!/bin/bash

# This script installs prerequisites for running the ELK stack with Docker on Ubuntu or Debian.

set -e  # Exit immediately if a command exits with a non-zero status.

# Detect the OS type
OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
    echo "This script is only compatible with Ubuntu or Debian."
    exit 1
fi

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies for Docker installation
echo "Installing dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/${OS}/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's official repository
echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${OS} $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
echo "Updating package index with Docker repository..."
sudo apt-get update -y

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker is already installed."
fi

# Enable and start Docker service
echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add the current user to the Docker group (requires logout and login to take effect)
if ! groups $USER | grep -q "docker"; then
    echo "Adding user to the Docker group..."
    sudo usermod -aG docker $USER
    echo "Please log out and log back in for Docker group changes to take effect."
fi

# Install Docker Compose if not already installed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
else
    echo "Docker Compose is already installed."
fi

# Verify installations
echo "Verifying installations..."
docker --version
docker-compose --version

# Success message
echo "All prerequisites for the ELK stack have been installed successfully."
