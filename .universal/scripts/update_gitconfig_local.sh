#!/bin/bash

MACHINE_NAME=$(hostname)

LOCAL_FILE=$HOME/.gitconfig.local
# Usa a variável, quando disponível, mas funciona também fora de um shell que carregou o .zshrc.
UNIVERSAL_DIR=${UNIVERSAL_DIR:-$HOME/.universal}
MACHINE_CONFIG=$UNIVERSAL_DIR/machines/git/.gitconfig.local.$MACHINE_NAME

if [ -f "$MACHINE_CONFIG" ]; then
    cp "$MACHINE_CONFIG" "$LOCAL_FILE"
    echo "Atualizado .gitconfig.local com base em $MACHINE_NAME"
else
    echo "Nenhum arquivo de configuração encontrado para $MACHINE_NAME"
    exit 1
fi
