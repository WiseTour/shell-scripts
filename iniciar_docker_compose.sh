#!/bin/bash

# Define o nome do serviço do banco de dados (ajuste se for diferente)
DB_SERVICE_NAME="db"

echo "Iniciando o serviço '$DB_SERVICE_NAME' em modo detached..."
docker-compose up -d "$DB_SERVICE_NAME"

# --- Loop para esperar o container DB estar "running" ---
echo "Aguardando o container '$DB_SERVICE_NAME' estar em execução..."
while [ "$(docker inspect -f '{{.State.Running}}' "$(docker-compose ps -q "$DB_SERVICE_NAME")" 2>/dev/null)" != "true" ]; do
  sleep 2 # Espera 2 segundos antes de tentar novamente
done
echo "Container '$DB_SERVICE_NAME' está em execução!"

# --- Loop para esperar o container DB estar "healthy" (melhor abordagem) ---
# Esta parte é ideal se você tem um healthcheck configurado no seu docker-compose.yml para 'db'
# Se você não tem um healthcheck, este loop pode não ser tão eficaz para a "prontidão do serviço".
echo "Aguardando o serviço '$DB_SERVICE_NAME' estar saudável (healthy)..."
MAX_RETRIES=60 # Tenta por no máximo 2 minutos (60 * 2 segundos)
RETRIES=0
while [ "$(docker inspect -f '{{.State.Health.Status}}' "$(docker-compose ps -q "$DB_SERVICE_NAME")" 2>/dev/null)" != "healthy" ] && \
      [ "$(docker inspect -f '{{.State.Running}}' "$(docker-compose ps -q "$DB_SERVICE_NAME")" 2>/dev/null)" == "true" ] && \
      [ "$RETRIES" -lt "$MAX_RETRIES" ]; do
  echo "Aguardando '$DB_SERVICE_NAME' ficar saudável... Tentativa $((RETRIES+1)) de $MAX_RETRIES"
  sleep 2
  RETRIES=$((RETRIES+1))
done

if [ "$RETRIES" -ge "$MAX_RETRIES" ]; then
    echo "ERRO: O serviço '$DB_SERVICE_NAME' não ficou saudável a tempo. Verifique os logs."
    docker-compose logs "$DB_SERVICE_NAME" --tail 50
    exit 1
fi

echo "Serviço '$DB_SERVICE_NAME' está pronto e saudável!"

# 1. Iniciar o serviço 'node' em modo detached
echo "Iniciando serviço 'node' em modo detached..."
docker-compose up -d node

# 2. Criar o container 'java' sem iniciá-lo
echo "Criando container 'java' sem iniciar..."
docker-compose create java

# 3. Executar o script do Java (presumindo que ele inicie o container 'java' ou faça algo com ele)
echo "Executando script './java/executar_container_java.sh'..."
./java/executar_container_java.sh

echo "Todos os comandos do Docker Compose foram processados."

# --- COMO VER OS LOGS DEPOIS ---
echo ""
echo "--- Para ver os logs dos serviços em tempo real ---"
echo "Em um novo terminal, use: docker-compose logs -f"
echo "Para parar os serviços: docker-compose down"
