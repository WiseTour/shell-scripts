#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Remove diretório antigo da aplicação, se existir
if [ -d "/home/ubuntu/WiseTourDiretory/aplication" ]; then
  sudo rm -rf "/home/ubuntu/WiseTourDiretory/aplication"
fi

# Clona o repositório da aplicação
git clone https://github.com/WiseTour/wise-tour.git /home/ubuntu/WiseTourDiretory/aplication

# Vai até o repositório
cd /home/ubuntu/WiseTourDiretory/aplication || { echo "Falha ao entrar no diretório da aplicação"; exit 1; }

# Cria o Dockerfile da aplicação Node.js sem COPY, usando git clone dentro do container
cat <<EOF > Dockerfile
FROM node:18
WORKDIR /app

# Clona o repositório diretamente no container
RUN git clone https://github.com/WiseTour/wise-tour.git . \
  && echo "APP_PORT=3333" > .env.dev \
  && echo "APP_HOST=localhost" >> .env.dev \
  && echo "DB_HOST=mysql-container-wise-tour" >> .env.dev \
  && echo "DB_DATABASE='WiseTour'" >> .env.dev \
  && echo "DB_USER=root" >> .env.dev \
  && echo "DB_PASSWORD=urubu100" >> .env.dev \
  && echo "DB_PORT=3306" >> .env.dev \
  && npm install

CMD ["npm", "start"]
EOF

# Remove imagem existente com o mesmo nome, se existir
if sudo docker images | grep -q "node-image-wise-tour"; then
  sudo docker rmi -f node-image-wise-tour
fi

# Cria imagem Docker da aplicação
sudo docker build -t node-image-wise-tour .

# Remove container existente com o mesmo nome, se existir
sudo docker rm -f aplicacao-node-wise-tour 2>/dev/null || true

# Executa o container Node.js na mesma rede
sudo docker run -d --name aplicacao-node-wise-tour --network wise-network -p 3333:3333 node-image-wise-tour

