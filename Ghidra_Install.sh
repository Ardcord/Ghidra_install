#!/bin/bash

# Vérification de l'utilisateur root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

# Variables d'installation dans le répertoire de l'utilisateur
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
GHIDRA_INSTALL_DIR="$USER_HOME/.ghidra"
OPENJDK_INSTALL_DIR="$GUIDRA_INSTALL_DIR/openjdk-17"

# Téléchargement des fichiers Ghidra et OpenJDK 17
GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0.1_build/ghidra_11.0.1_PUBLIC_20240130.zip"
OPENJDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.10_7.tar.gz"

# Téléchargement des fichiers
wget "$GHIDRA_URL" -O /tmp/ghidra.zip
wget "$OPENJDK_URL" -O /tmp/openjdk.tar.gz

# Création des répertoires d'installation si nécessaire
mkdir -p "$GHIDRA_INSTALL_DIR"
mkdir -p "$OPENJDK_INSTALL_DIR"

# Extraction des fichiers
unzip /tmp/ghidra.zip -d "$GHIDRA_INSTALL_DIR"
tar -xzf /tmp/openjdk.tar.gz -C "$OPENJDK_INSTALL_DIR" --strip-components=1

# Nettoyage des fichiers temporaires
rm /tmp/ghidra.zip
rm /tmp/openjdk.tar.gz

# Ajout des chemins d'accès au PATH de l'utilisateur
echo "export PATH=\$PATH:$GHIDRA_INSTALL_DIR/ghidra_11.0.1_PUBLIC" >> "$USER_HOME/.zshrc"
echo "export PATH=\$PATH:$OPENJDK_INSTALL_DIR/bin" >> "$USER_HOME/.zshrc"

# Téléchargement de l'icône Ghidra
wget "https://upload.wikimedia.org/wikipedia/commons/f/f6/Ghidra_logo.svg" -O "$GHIDRA_INSTALL_DIR/ghidra_11.0.1_PUBLIC/ghidra.ico"

# Création du lanceur d'application
echo "[Desktop Entry]
Name=Ghidra
Comment=Software Reverse Engineering Framework
Exec=$GHIDRA_INSTALL_DIR/ghidra_11.0.1_PUBLIC/ghidraRun
Icon=$GHIDRA_INSTALL_DIR/ghidra_11.0.1_PUBLIC/ghidra.ico
Terminal=false
Type=Application
Categories=Development;" > "$USER_HOME/.local/share/applications/ghidra.desktop"

sudo chmod 777 "$USER_HOME/.ghidra/ghidra_11.0.1_PUBLIC/ghidraRun"
sudo chmod 777 "$USER_HOME/.ghidra"
sudo chmod 777 "$USER_HOME/.ghidra/ghidra_11.0.1_PUBLIC"
sudo chmod 777 "$USER_HOME/.ghidra/ghidra_11.0.1_PUBLIC/openjdk-17"

# Informer l'utilisateur que l'installation est terminée
echo "Ghidra a été installés avec succès."

echo "au lancement de Ghidra, il est possible que vous ayez à ajouter le path d'OpenJDK 17"
echo "pour cela, il suffit de rentrer la ligne suivante dans le terminal :"
echo ""
echo "$USER_HOME/.ghidra/ghidra_11.0.1_PUBLIC/openjdk-17"
echo ""