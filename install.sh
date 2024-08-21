#!/bin/bash

set -e

REPO="pkb-code/Keyhouse-releases"
CLI="keyhouse"
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Detectar OS
OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
    Linux)
        case $ARCH in
            x86_64)
                TARGET="linux-amd64"
                ;;
            aarch64)
                TARGET="linux-arm64"
                ;;
            *)
                echo "Arquitectura no soportada: $ARCH"
                exit 1
                ;;
        esac
        ;;
    CYGWIN*|MINGW*|MSYS*|Windows_NT)
        TARGET="windows-amd64.exe"
        ;;
    *)
        echo "Sistema operativo no soportado: $OS"
        exit 1
        ;;
esac

# Crear directorio $HOME/bin si no existe
mkdir -p "$HOME/bin"

# Descargar el binario
curl -L "https://github.com/$REPO/releases/download/$LATEST_RELEASE/${CLI}-${TARGET}" -o "$HOME/bin/$CLI"

# Hacer ejecutable el binario
chmod +x "$HOME/bin/$CLI"

# Agregar $HOME/bin al PATH si no está
if ! echo "$PATH" | grep -q "$HOME/bin"; then
    echo "export PATH=\$PATH:\$HOME/bin" >> "$HOME/.bashrc"
    echo "Recarga tu shell o ejecuta 'source \$HOME/.bashrc' para actualizar tu PATH."
fi

echo "$CLI instalado exitosamente en $HOME/bin"
