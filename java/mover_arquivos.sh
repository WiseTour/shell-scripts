#!/bin/bash

BUCKET="s3-wise-tour"
DESTINO="arquivosTratados"

aws s3 ls s3://$BUCKET/ --recursive | awk '{$1=$2=$3=""; print substr($0,4)}' | while IFS= read -r arquivo; do
    arquivo=$(echo "$arquivo" | sed 's/^ *//;s/ *$//')  # trim espaços

    # pula linhas vazias
    if [ -z "$arquivo" ]; then
        continue
    fi

    # pula arquivos dentro de subdiretórios
    if [[ "$arquivo" == *"/"* ]]; then
        echo "Pulando arquivo em subdiretório: $arquivo"
        continue
    fi

    # pula arquivos já dentro do destino
    if [[ "$arquivo" == "$DESTINO"* ]]; then
        echo "Arquivo já está no destino, pulando: $arquivo"
        continue
    fi

    echo "Movendo '$arquivo' para $DESTINO/"

    aws s3 cp "s3://$BUCKET/$arquivo" "s3://$BUCKET/$DESTINO/$arquivo"
    if [ $? -eq 0 ]; then
        aws s3 rm "s3://$BUCKET/$arquivo"
        echo "Arquivo '$arquivo' movido com sucesso!"
    else
        echo "Erro ao mover o arquivo '$arquivo'"
    fi
done
