# Ghidra Install

Script d'installation automatique de **Ghidra** (framework de rétro-ingénierie de la NSA) et **OpenJDK 17** sur Linux.

## Fonctionnalités

- Récupère automatiquement la **dernière version** de Ghidra et OpenJDK 17 (Temurin)
- Installe dans `~/.ghidra/` (répertoire utilisateur)
- Configure le PATH (`.zshrc` ou `.bashrc`)
- Crée un lanceur d'application (`.desktop`)
- Permissions sécurisées (755/750, pas de 777)

## Prérequis

- Linux (Debian, Ubuntu, Arch, etc.)
- Paquets nécessaires : `wget`, `unzip`, `tar`, `curl`, `jq`
- Droits root/sudo

### Installation des dépendances (Debian/Ubuntu)

```bash
sudo apt install wget unzip tar curl jq
```

## Installation

```bash
git clone https://github.com/ardcord/Ghidra_install.git
cd Ghidra_install
chmod +x Ghidra_Install.sh
sudo ./Ghidra_Install.sh
```

## Arborescence après installation

```
~/.ghidra/
├── ghidra_<version>_PUBLIC/
│   ├── ghidraRun          # Lanceur Ghidra
│   └── ghidra.ico         # Icône
└── openjdk-17/
    └── bin/               # Binaires Java
```

## Notes importantes

- Le script détecte automatiquement la dernière release via l'API GitHub (Ghidra) et l'API Adoptium (OpenJDK)
- Au premier lancement, Ghidra peut demander le chemin vers OpenJDK. Indiquez : `~/.ghidra/openjdk-17`
- Si vous utilisez **bash** au lieu de **zsh**, le script ajoutera le PATH dans `.bashrc` automatiquement
- Les paths sont ajoutés une seule fois (pas de doublons)
