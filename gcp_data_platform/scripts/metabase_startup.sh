#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io postgresql

# Configurar PostgreSQL
sudo -u postgres psql -c "CREATE DATABASE metabase_db;"
sudo -u postgres psql -c "CREATE USER metabase_user WITH ENCRYPTED PASSWORD 'senha_segura';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE metabase_db TO metabase_user;"

# Configurar Metabase para usar o PostgreSQL local
export MB_DB_TYPE=postgres
export MB_DB_DBNAME=metabase_db
export MB_DB_PORT=5432
export MB_DB_USER=metabase_user
export MB_DB_PASS=senha_segura
export MB_DB_HOST=localhost

# Iniciar o Docker e o Metabase
sudo systemctl start docker
sudo systemctl enable docker
sudo docker run --restart unless-stopped -d -p 3000:3000 -e MB_DB_TYPE -e MB_DB_DBNAME -e MB_DB_PORT -e MB_DB_USER -e MB_DB_PASS -e MB_DB_HOST metabase/metabase
