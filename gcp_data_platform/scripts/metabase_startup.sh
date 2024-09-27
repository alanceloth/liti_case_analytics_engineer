#!/bin/bash
sudo apt-get update
sudo apt-get install -y curl git python3-pip docker.io docker-compose nginx postgresql

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


# Configurar o Nginx como proxy reverso

# Criar arquivo de configuração do Nginx para o Airflow
sudo tee /etc/nginx/sites-available/airflow <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }
}
EOF

# Remover o link simbólico padrão do Nginx
sudo rm /etc/nginx/sites-enabled/default

# Ativar a nova configuração do Airflow
sudo ln -s /etc/nginx/sites-available/airflow /etc/nginx/sites-enabled/

# Testar a configuração do Nginx
sudo nginx -t

# Reiniciar o Nginx para aplicar as alterações
sudo systemctl restart nginx

sleep 10

sudo docker run --restart unless-stopped -d -p 3000:3000 -e MB_DB_TYPE -e MB_DB_DBNAME -e MB_DB_PORT -e MB_DB_USER -e MB_DB_PASS -e MB_DB_HOST metabase/metabase
