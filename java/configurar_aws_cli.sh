#!/bin/bash

CONFIG_FILE="config.properties"

echo "=== Configurando AWS CLI com base em $CONFIG_FILE ==="

# Verifica se o arquivo existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Arquivo $CONFIG_FILE não encontrado!"
    exit 1
fi

# Lê o conteúdo do arquivo e exporta as variáveis como variáveis de ambiente
export $(grep -v '^#' "$CONFIG_FILE" | xargs)

# Define nome do perfil (você pode trocar "default" por outro nome se quiser múltiplos perfis)
PROFILE_NAME="default"

# Garante que a pasta de configuração da AWS existe
mkdir -p ~/.aws

# Salva as credenciais
cat > ~/.aws/credentials <<EOF
[$PROFILE_NAME]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
aws_session_token = $aws_session_token
EOF

# Salva a configuração (região e formato de saída)
cat > ~/.aws/config <<EOF
[profile $PROFILE_NAME]
region = $AWS_BUCKET_REGION
output = json
EOF

echo "✅ AWS CLI configurada com sucesso usando perfil '$PROFILE_NAME'."
