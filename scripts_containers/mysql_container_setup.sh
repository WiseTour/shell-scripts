#!/bin/bash

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

# Executa o MySQL na rede
sudo docker run -d --name mysql-container-wise-tour --network wise-network -e MYSQL_ROOT_PASSWORD=urubu100 -e MYSQL_DATABASE=WiseTour -p 3306:3306 mysql-image-wise-tour

# Aguarda até que o MySQL esteja pronto para conexões (timeout: 60s)
echo "Aguardando o MySQL iniciar..."

timeout=60
elapsed=0
until sudo docker logs mysql-container-wise-tour 2>&1 | grep -q "ready for connections"; do
  sleep 2
  elapsed=$((elapsed + 2))
  if [ "$elapsed" -ge "$timeout" ]; then
    echo "Erro: MySQL não iniciou dentro do tempo esperado."
    exit 1
  fi
done

echo "MySQL pronto para conexões!"

sudo docker exec -i mysql-container-wise-tour mysql -u root -purubu100 <<EOF
CREATE USER IF NOT EXISTS 'wiseuser'@'%' IDENTIFIED BY 'urubu100';
GRANT ALL PRIVILEGES ON *.* TO 'wiseuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

