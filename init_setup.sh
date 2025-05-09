#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o Docker de forma não interativa
sudo apt install -y docker.io

# Ativa e inicia o Docker
sudo systemctl enable docker && sudo systemctl start docker
