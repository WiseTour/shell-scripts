#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o Docker de forma não interativa
sudo apt install -y docker.io

# Ativa e inicia o Docker
sudo systemctl enable docker && sudo systemctl start docker

# Instalando docker compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Tornando ele executável
sudo chmod +x /usr/local/bin/docker-compose


REPO_URL="https://github.com/WiseTour/database.git"
DEST_DIR="mysql/database"

if [ -d "$DEST_DIR/.git" ]; then
  echo "Repositório já existe. Atualizando com git pull..."
  cd "$DEST_DIR" && git pull
else
  echo "Repositório não encontrado. Clonando com git clone..."
  git clone "$REPO_URL" "$DEST_DIR"
fi
