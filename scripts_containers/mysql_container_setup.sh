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
ENV MYSQL_ROOT_PASSWORD=urubu100
ENV MYSQL_PASSWORD=urubu100

# Copia os scripts SQL para o diretório de inicialização do MySQL
COPY ./script/*.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
EOF

# Verifica e remove o container existente
if sudo docker ps -a --format '{{.Names}}' | grep -q '^mysql-container-wise-tour$'; then
  echo "Removendo container antigo mysql-container-wise-tour..."
  sudo docker rm -f mysql-container-wise-tour
fi

# Verifica e remove a imagem existente
if sudo docker images --format '{{.Repository}}' | grep -q '^mysql-image-wise-tour$'; then
  echo "Removendo imagem antiga mysql-image-wise-tour..."
  sudo docker rmi -f mysql-image-wise-tour
fi

# Constrói a imagem
sudo docker build -t mysql-image-wise-tour .

# Executa o container
sudo docker run -d -p 3306:3306 --name mysql-container-wise-tour mysql-image-wise-tour

sudo docker exec -it mysql-container-wise-tour mysql -h127.0.0.1 -u wiseuser -p <<EOF
CREATE USER IF NOT EXISTS 'wiseuser'@'%' IDENTIFIED BY 'urubu100';
GRANT ALL PRIVILEGES ON *.* TO 'wiseuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
