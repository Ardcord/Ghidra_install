# Ghidra_install

This repository contains a script for installing Ghidra, a software reverse engineering (SRE) framework developed by the National Security Agency (NSA), along with OpenJDK 17 on Linux systems.

## Description

The script automates the process of downloading and installing Ghidra and OpenJDK 17. It also sets up the environment by adding the necessary paths to the user's `.zshrc` file for easy execution of Ghidra from the command line.

## Prerequisites

- A Linux-based operating system.
- `wget` utility installed for downloading files.
- `unzip` and `tar` utilities for extracting downloaded archives.
- Root or sudo privileges for executing the script.

## Installation

1. Download the installation script from this repository.
2. Open a terminal and navigate to the directory where you downloaded the script.
3. Make the script executable:
   ```bash
   chmod +x ghidra_install.sh
   ```

4. Execute the script with root privileges:
    ```bash
    sudo ./ghidra_install.sh
    ```
   
Important Notes

    The script must be run with root privileges to ensure proper installation.
    It automatically downloads Ghidra and OpenJDK 17, installs them in the user's home directory, and configures the environment.
    Paths to Ghidra and OpenJDK binaries are added to the .zshrc file. If you are using a different shell, you may need to add the paths to the appropriate configuration file for your shell.
