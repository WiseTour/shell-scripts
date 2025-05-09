#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o Docker de forma não interativa
sudo apt install -y docker.io

# Ativa e inicia o Docker
sudo systemctl enable docker && sudo systemctl start docker

cd scripts_containers/

# Configura os scripts para executaveis
chmod +x mysql_container_setup.sh
chmod +x site_container_setup.sh

# Executa os scripts
./mysql_container_setup.sh
./site_container_setup.sh
