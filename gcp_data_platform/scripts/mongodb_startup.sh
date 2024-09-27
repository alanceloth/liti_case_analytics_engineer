#!/bin/bash
# Atualizar pacotes
sudo apt-get update

# Instalar o MongoDB
sudo apt-get install -y wget gnupg

# Importar a chave pública do MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Criar arquivo de lista para o MongoDB
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Atualizar novamente
sudo apt-get update

# Instalar o MongoDB
sudo apt-get install -y mongodb-org

# Iniciar o serviço do MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Criar diretório temporário
mkdir -p /tmp/data

# Baixar o arquivo weighins.json (substitua pela URL correta ou copie o arquivo)
# Se o arquivo estiver em um bucket do GCS, use gsutil para copiar
 gsutil cp gs://liti_case_analytics_engineer_filedump/files/weighins.json /tmp/data/weighins.json

# Para este exemplo, assumiremos que o arquivo está disponível em uma URL pública
#wget -O /tmp/data/weighins.json https://seu-endereco/weighins.json

# Importar os dados para o MongoDB
mongoimport --db liti_db --collection weighins --file /tmp/data/weighins.json --jsonArray

gcloud pubsub topics publish vm-status-topic --message="VM $(hostname) pronta para uso às $(date)"
