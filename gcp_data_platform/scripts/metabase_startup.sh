#!/bin/bash

# Atualizar pacotes e instalar dependências
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

# Criar arquivo de configuração do Nginx para o Metabase e Briefer
sudo tee /etc/nginx/sites-available/analytics <<EOF
server {
    listen 80;
    server_name _;

    # Proxy para o Metabase (porta 3000)
    location /metabase/ {
        proxy_pass http://localhost:3000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    # Proxy para o Briefer (porta 3001)
    location /briefer/ {
        proxy_pass http://localhost:3001/;
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

# Ativar a nova configuração do Nginx
sudo ln -s /etc/nginx/sites-available/analytics /etc/nginx/sites-enabled/

# Testar a configuração do Nginx
sudo nginx -t

# Reiniciar o Nginx para aplicar as alterações
sudo systemctl restart nginx

# Adicionar hostnames amigáveis ao arquivo /etc/hosts localmente
sudo tee -a /etc/hosts <<EOF
127.0.0.1 metabase.liti
127.0.0.1 briefer.liti
EOF

# Esperar um tempo para garantir que os serviços sejam iniciados corretamente
sleep 10

# Iniciar Metabase
sudo docker run --restart unless-stopped -d \
  -p 3000:3000 \
  -e MB_DB_TYPE \
  -e MB_DB_DBNAME \
  -e MB_DB_PORT \
  -e MB_DB_USER \
  -e MB_DB_PASS \
  -e MB_DB_HOST \
  metabase/metabase

# Iniciar Briefer
sudo docker run --restart unless-stopped -d \
  -p 3001:3000 \
  --env ALLOW_HTTP="true" \
  -v briefer_psql_data:/var/lib/postgresql/data \
  -v briefer_jupyter_data:/home/jupyteruser \
  -v briefer_briefer_data:/home/briefer \
  briefercloud/briefer


# Enviar notificação via Google Cloud Pub/Sub sobre o status da VM
gcloud pubsub topics publish vm-status-topic --message="VM $(hostname) pronta para uso às $(date)"
