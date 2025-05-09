#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o Docker de forma não interativa
sudo apt install -y docker.io

# Ativa e inicia o Docker
sudo systemctl enable docker && sudo systemctl start docker

cd scripts_containers/

sudo docker network create wise-network

# Configura os scripts para executaveis
sudo chmod +x mysql_container_setup.sh
sudo chmod +x site_container_setup.sh

# Executa os scripts
./mysql_container_setup.sh
./site_container_setup.sh
