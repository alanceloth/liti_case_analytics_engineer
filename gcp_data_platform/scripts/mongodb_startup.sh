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

# Substituir o conteúdo do arquivo /etc/mongod.conf
sudo bash -c 'cat > /etc/mongod.conf <<EOF
#mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
#  engine:
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0

# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo

# security:
#  authorization: enabled

#operationProfiling:

replication:
  replSetName: "rs0"

#sharding:

## Enterprise-Only Options:

#auditLog:

#snmp:
EOF'


# Reiniciar o MongoDB para aplicar as configurações
sudo systemctl restart mongod

# Criar o script temporário para inicializar o Replica Set
cat <<EOF > /tmp/init_replica_set.js
rs.initiate()
EOF

# Executar o script no MongoDB para iniciar o Replica Set
mongosh < /tmp/init_replica_set.js

# Remover o arquivo temporário
rm /tmp/init_replica_set.js

# Criar diretório temporário
mkdir -p /tmp/data

# Baixar o arquivo weighins.json (substitua pela URL correta ou copie o arquivo)
# Se o arquivo estiver em um bucket do GCS, use gsutil para copiar
gsutil cp gs://liti_case_analytics_engineer_filedump/files/weighins.json /tmp/data/weighins.json

# Para este exemplo, assumiremos que o arquivo está disponível em uma URL pública
#wget -O /tmp/data/weighins.json https://seu-endereco/weighins.json

# Importar os dados para o MongoDB
mongoimport --db liti_db --collection weighins --file /tmp/data/weighins.json --jsonArray

mongosh --eval 'use admin; db.createUser({ user: "airbyte_user", pwd: "airbyte123", roles: [{ role: "readWrite", db: "liti_db" }] });'

gcloud pubsub topics publish vm-status-topic --message="VM $(hostname) pronta para uso às $(date)"
