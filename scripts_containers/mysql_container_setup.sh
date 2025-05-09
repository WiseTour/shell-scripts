#!/bin/bash
set -e # Encerra o script imediatamente se algum comando falhar

# Configurações
REPO_URL="https://github.com/WiseTour/database.git"
CLONE_DIR="/home/ubuntu/wise-tour/database"
IMAGE_NAME="mysql-image-wise-tour"
CONTAINER_NAME="mysql-container-wise-tour"
NETWORK_NAME="wise-network"
MYSQL_ROOT_PASSWORD="urubu100"

# Função para limpar recursos existentes
cleanup() {
    echo "Verificando recursos existentes..."
    
    # Parar e remover container
    if sudo docker ps -a | grep -q $CONTAINER_NAME; then
        echo "Removendo container existente: $CONTAINER_NAME"
        sudo docker rm -f $CONTAINER_NAME || true
    fi

    # Remover imagem
    if sudo docker images | grep -q $IMAGE_NAME; then
        echo "Removendo imagem existente: $IMAGE_NAME"
        sudo docker rmi -f $IMAGE_NAME || true
    fi

    # Limpar volumes não utilizados
    echo "Limpando volumes não utilizados..."
    sudo docker volume prune -f
}

# Clonar repositório
clone_repository() {
    echo "Clonando repositório..."
    if [ ! -d "$CLONE_DIR" ]; then
        git clone $REPO_URL $CLONE_DIR
    else
        echo "Diretório já existe. Atualizando repositório..."
        git -C $CLONE_DIR pull
    fi
}

# Criar Dockerfile
create_dockerfile() {
    echo "Criando Dockerfile..."
    cat <<EOF > $CLONE_DIR/Dockerfile
FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
ENV MYSQL_DATABASE=WiseTour

COPY ./script/*.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
EOF
}

# Criar rede Docker
create_network() {
    if ! sudo docker network inspect $NETWORK_NAME &>/dev/null; then
        echo "Criando rede: $NETWORK_NAME"
        sudo docker network create $NETWORK_NAME
    fi
}

# Verificar saúde do MySQL
wait_for_mysql() {
    echo "Aguardando inicialização do MySQL..."
    local timeout=60
    local start_time=$(date +%s)

    while ! sudo docker exec $CONTAINER_NAME mysqladmin ping -uroot -p$MYSQL_ROOT_PASSWORD --silent; do
        if [ $(($(date +%s) - start_time)) -ge $timeout ]; then
            echo "Erro: Timeout na inicialização do MySQL"
            exit 1
        fi
        sleep 2
    done
}

# Execução principal
main() {
    cleanup
    clone_repository
    create_dockerfile
    create_network

    # Construir e executar container
    echo "Construindo nova imagem..."
    (cd $CLONE_DIR && sudo docker build -t $IMAGE_NAME .)

    echo "Iniciando novo container..."
    sudo docker run -d \
        --name $CONTAINER_NAME \
        --network $NETWORK_NAME \
        -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
        -p 3306:3306 \
        $IMAGE_NAME

    wait_for_mysql

    # Executar comandos adicionais no MySQL
    echo "Configurando usuário e permissões..."
    sudo docker exec -i $CONTAINER_NAME mysql -uroot -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE USER IF NOT EXISTS 'wiseuser'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON WiseTour.* TO 'wiseuser'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Implantação concluída com sucesso!"
}

main
