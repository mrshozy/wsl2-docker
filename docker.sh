#!/bin/bash

# Ensure no older packages are installed
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# Ensure pre-requisites are installed
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker apt key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker apt repository
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh apt repositories
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ensure docker group exists
sudo groupadd docker

# Ensure the current user is part of the docker group
sudo usermod -aG docker $USER

# Find the latest version of docker-compose-switch
switch_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose-switch/releases/latest | xargs basename)

# Download the binary for docker-compose-switch
sudo curl -fL -o /usr/local/bin/docker-compose \
    "https://github.com/docker/compose-switch/releases/download/${switch_version}/docker-compose-linux-$(dpkg --print-architecture)"

# Assign execution permission to it
sudo chmod +x /usr/local/bin/docker-compose

echo "Docker installation and configuration is complete. Please close your shell and open a new one to apply the group changes."