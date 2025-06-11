#!/bin/bash

# Inicia o container
echo "Iniciando o container java"
docker start -a java-container

# Espera até o container parar
echo "Esperando o container java encerrar..."
docker wait java-container

# Verifica o status de saída do container
EXIT_CODE=$(docker inspect java-container --format='{{.State.ExitCode}}')

# Se terminou com sucesso, roda o mover_arquivos.sh
if [ "$EXIT_CODE" -eq 0 ]; then
    echo "Container finalizado com sucesso. Executando mover_arquivos.sh..."
    ./java/mover_arquivos.sh
else
    echo "Container finalizado com erro (exit code $EXIT_CODE). Não será executado o script de movimentação."
fi
