#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o docker
sudo apt install  docker.io

# Ativa e inicia o Docker
sudo systemctl enable docker
sudo systemctl start docker

# Clona o repositório com os scripts SQL
git clone https://github.com/WiseTour/database.git /home/ubuntu/wise-tour/database

# Vai até o repositório
cd /home/ubuntu/wise-tour/database/

# Cria o Dockerfile automaticamente
cat <<EOF > Dockerfile
FROM mysql:latest

# Define variáveis de ambiente obrigatórias
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_PASSWORD=urubu100

# Copia os scripts SQL para o diretório de inicialização do MySQL
COPY ./script/*.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
EOF

# Constrói a imagem
sudo docker build -t mysql-image-wise-tour .

# Executa o container
sudo docker run -d -p 3306:3306 --name mysql-container-wise-tour mysql-image-wise-tour
