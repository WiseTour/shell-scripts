#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o docker
sudo apt install  docker.io

# Ativa e inicia o Docker
sudo systemctl enable docker
sudo systemctl start docker

# Clona o repositório com os scripts SQL
git clone https://github.com/WiseTour/database.git /var/database

# Cria um diretório para o Dockerfile
mkdir -p /var/mysql-docker
cd /var/mysql-docker

# Cria o Dockerfile automaticamente
touch Dockerfile
echo "FROM mysql:8.0" >> Dockerfile
echo "ENV MYSQL_ROOT_PASSWORD=root" >> Dockerfile
echo "ENV MYSQL_PASSWORD=urubu100" >> Dockerfile
echo "COPY ./script /docker-entrypoint-initdb.d" >> Dockerfile
echo "EXPOSE 3306" >> Dockerfile
# Copia os scripts do repositório clonado para o diretório do Dockerfile
mkdir -p scripts
cp /var/database/script/*.sql scripts/

# Constrói a imagem
sudo docker build -t mysql-image-wise-tour .

# Executa o container
sudo docker run -d -p 3306:3306 --name mysql-container-wise-tour mysql-image-wise-tour
