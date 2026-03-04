#!/bin/bash
set -e

# Vérification de l'utilisateur root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

# Vérification des dépendances
for cmd in wget unzip tar curl jq; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Erreur : '$cmd' n'est pas installé. Installez-le avec : apt install $cmd"
        exit 1
    fi
done

# Variables d'installation
USER_HOME="/home/$(logname)"
GHIDRA_INSTALL_DIR="$USER_HOME/.ghidra"

# Récupération de la dernière version de Ghidra via l'API GitHub
echo "Récupération de la dernière version de Ghidra..."
GHIDRA_LATEST=$(curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest)
GHIDRA_URL=$(echo "$GHIDRA_LATEST" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url')
GHIDRA_TAG=$(echo "$GHIDRA_LATEST" | jq -r '.tag_name')
GHIDRA_ZIP_NAME=$(echo "$GHIDRA_LATEST" | jq -r '.assets[] | select(.name | endswith(".zip")) | .name')
GHIDRA_DIR_NAME=$(basename "$GHIDRA_ZIP_NAME" .zip)

if [ -z "$GHIDRA_URL" ] || [ "$GHIDRA_URL" = "null" ]; then
    echo "Erreur : impossible de récupérer la dernière version de Ghidra."
    exit 1
fi
echo "Version détectée : $GHIDRA_TAG"

# Récupération de la dernière version d'OpenJDK 17 (Temurin)
echo "Récupération de la dernière version d'OpenJDK 17..."
OPENJDK_LATEST=$(curl -s "https://api.adoptium.net/v3/assets/latest/17/hotspot?os=linux&architecture=x64&image_type=jdk")
OPENJDK_URL=$(echo "$OPENJDK_LATEST" | jq -r '.[0].binary.package.link')
OPENJDK_VERSION=$(echo "$OPENJDK_LATEST" | jq -r '.[0].version.semver')

if [ -z "$OPENJDK_URL" ] || [ "$OPENJDK_URL" = "null" ]; then
    echo "Erreur : impossible de récupérer la dernière version d'OpenJDK 17."
    exit 1
fi
echo "Version détectée : OpenJDK $OPENJDK_VERSION"

OPENJDK_INSTALL_DIR="$GHIDRA_INSTALL_DIR/openjdk-17"

# Téléchargement des fichiers
echo "Téléchargement de Ghidra..."
wget -q --show-progress "$GHIDRA_URL" -O /tmp/ghidra.zip

echo "Téléchargement d'OpenJDK 17..."
wget -q --show-progress "$OPENJDK_URL" -O /tmp/openjdk.tar.gz

# Création des répertoires d'installation
mkdir -p "$GHIDRA_INSTALL_DIR"
mkdir -p "$OPENJDK_INSTALL_DIR"

# Extraction des fichiers
echo "Extraction de Ghidra..."
unzip -qo /tmp/ghidra.zip -d "$GHIDRA_INSTALL_DIR"

echo "Extraction d'OpenJDK 17..."
tar -xzf /tmp/openjdk.tar.gz -C "$OPENJDK_INSTALL_DIR" --strip-components=1

# Nettoyage des fichiers temporaires
rm -f /tmp/ghidra.zip /tmp/openjdk.tar.gz

# Ajout des chemins d'accès au PATH de l'utilisateur
SHELL_RC="$USER_HOME/.zshrc"
if [ ! -f "$SHELL_RC" ]; then
    SHELL_RC="$USER_HOME/.bashrc"
fi

# Éviter les doublons dans le PATH
grep -qxF "export PATH=\$PATH:$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME" "$SHELL_RC" 2>/dev/null || \
    echo "export PATH=\$PATH:$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME" >> "$SHELL_RC"
grep -qxF "export PATH=\$PATH:$OPENJDK_INSTALL_DIR/bin" "$SHELL_RC" 2>/dev/null || \
    echo "export PATH=\$PATH:$OPENJDK_INSTALL_DIR/bin" >> "$SHELL_RC"

# Téléchargement de l'icône Ghidra
wget -q "https://upload.wikimedia.org/wikipedia/commons/f/f6/Ghidra_logo.svg" -O "$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME/ghidra.ico"

# Création du lanceur d'application
mkdir -p "$USER_HOME/.local/share/applications"
cat > "$USER_HOME/.local/share/applications/ghidra.desktop" <<EOF
[Desktop Entry]
Name=Ghidra
Comment=Software Reverse Engineering Framework
Exec=$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME/ghidraRun
Icon=$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME/ghidra.ico
Terminal=false
Type=Application
Categories=Development;
EOF

# Permissions sécurisées (PAS de 777)
chown -R "$(logname):$(logname)" "$GHIDRA_INSTALL_DIR"
chmod 755 "$GHIDRA_INSTALL_DIR"
chmod 755 "$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME"
chmod 755 "$GHIDRA_INSTALL_DIR/openjdk-17"
chmod 750 "$GHIDRA_INSTALL_DIR/$GHIDRA_DIR_NAME/ghidraRun"

echo ""
echo "Ghidra $GHIDRA_TAG + OpenJDK $OPENJDK_VERSION installés avec succès."
echo ""
echo "Au lancement de Ghidra, si le path OpenJDK est demandé :"
echo "  $OPENJDK_INSTALL_DIR"
echo ""
