# Docker Installation Script for WSL 2

This script automates the installation of Docker on WSL 2 (Windows Subsystem for Linux 2). It removes any older Docker packages, installs necessary prerequisites, sets up Docker's official GPG key and repository, installs Docker CE, adds the user to the `docker` group, and installs the latest version of `docker-compose-switch`.

## Prerequisites

- WSL 2 installed on your Windows system.
- A WSL 2 Linux distribution (e.g., Ubuntu).

## Installation

### Using the Script

1. **Download the Script:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/mrshozy/wsl2-docker/main/install_docker.sh
   ```

2. **Make the Script Executable:**
   ```bash
   chmod +x install_docker.sh
   ```

3. **Run the Script:**
   ```bash
   ./install_docker.sh
   ```

### Using `curl`

1. **Run the Script Directly with `curl`:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/mrshozy/wsl2-docker/main/install_docker.sh | bash
   ```

## Post-Installation Steps

After running the script, you need to close your shell and open a new one to apply the group changes. This ensures that your user is part of the `docker` group.

## Script Details

The script performs the following tasks:

1. **Removes any older Docker packages:**
   ```bash
   sudo apt-get remove -y docker docker-engine docker.io containerd runc
   ```

2. **Installs necessary prerequisites:**
   ```bash
   sudo apt-get update
   sudo apt-get install -y \
       ca-certificates \
       curl \
       gnupg \
       lsb-release
   ```

3. **Adds Docker apt key:**
   ```bash
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```

4. **Adds Docker apt repository:**
   ```bash
   echo \
       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. **Refreshes apt repositories:**
   ```bash
   sudo apt-get update
   ```

6. **Installs Docker CE:**
   ```bash
   sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

7. **Ensures the `docker` group exists:**
   ```bash
   sudo groupadd docker
   ```

8. **Adds the current user to the `docker` group:**
   ```bash
   sudo usermod -aG docker $USER
   ```

9. **Finds the latest version of `docker-compose-switch`:**
   ```bash
   switch_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose-switch/releases/latest | xargs basename)
   ```

10. **Downloads the binary for `docker-compose-switch`:**
    ```bash
    sudo curl -fL -o /usr/local/bin/docker-compose \
        "https://github.com/docker/compose-switch/releases/download/${switch_version}/docker-compose-linux-$(dpkg --print-architecture)"
    ```

11. **Assigns execution permission to it:**
    ```bash
    sudo chmod +x /usr/local/bin/docker-compose
    ```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---
