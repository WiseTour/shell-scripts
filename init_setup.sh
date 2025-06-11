#!/bin/bash

set -e  # Encerra o script se qualquer comando falhar

echo "=== Atualizando o sistema ==="
set -e  # Encerra o script se qualquer comando falhar

echo "=== Atualizando o sistema ==="
sudo apt update && sudo apt upgrade -y

echo "=== Instalando Docker ==="
echo "=== Instalando Docker ==="
sudo apt install -y docker.io

echo "=== Ativando o serviço Docker ==="
echo "=== Ativando o serviço Docker ==="
sudo systemctl enable docker && sudo systemctl start docker

echo "=== Instalando Docker Compose ==="
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
echo "=== Instalando Docker Compose ==="
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== Instalando unzip (se necessário) ==="
sudo apt install -y unzip

echo "=== Instalando AWS CLI ==="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "=== Configurando variáveis de ambiente ==="
cd java/
./configurar_aws_cli.sh
cd ..

echo "=== Clonando ou atualizando o repositório do banco de dados ==="
REPO_URL="https://github.com/WiseTour/database.git"
DEST_DIR="mysql/database"

if [ -d "$DEST_DIR/.git" ]; then
  echo "Repositório já existe. Atualizando com git pull..."
  cd "$DEST_DIR" && git pull
else
  echo "Repositório não encontrado. Clonando com git clone..."
  git clone "$REPO_URL" "$DEST_DIR"
fi

echo "✅ Configuração inicial finalizada com sucesso!"

echo "✅ Configuração inicial finalizada com sucesso!"
