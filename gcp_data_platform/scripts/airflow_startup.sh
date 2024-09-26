#!/bin/bash

# Atualizar pacotes e instalar dependências
sudo apt-get update

# Instalar pacotes necessários
sudo apt-get install -y curl git python3-pip docker.io docker-compose nginx

# Iniciar e habilitar o Docker
sudo systemctl start docker
sudo systemctl enable docker

# Adicionar o usuário atual ao grupo docker
sudo usermod -aG docker $USER
# Aplicar a nova associação ao grupo docker
newgrp docker

# Instalar o astro CLI
curl -sSL https://install.astronomer.io | sudo bash

# Verificar se o astro CLI foi instalado corretamente
astro version

# Criar o diretório do projeto Airflow
mkdir -p /home/${USER}/airflow-project
cd /home/${USER}/airflow-project

# Inicializar um projeto Airflow usando o astro CLI
astro dev init

# Instalar o Cosmos e dependências do dbt
echo "astronomer-cosmos==1.6.0" >> requirements.txt
echo "dbt-core==1.8.7" >> requirements.txt
echo "dbt-bigquery==1.8.2" >> requirements.txt

# Criar o arquivo docker-compose.override.yaml para configurar o Airflow
cat <<EOL > docker-compose.override.yaml
version: '3'
services:
  webserver:
    environment:
      - AIRFLOW__WEBSERVER__ENABLE_PROXY_FIX=True
      - AIRFLOW__WEBSERVER__WEB_SERVER_HOST=0.0.0.0
EOL

# Configurar o Nginx como proxy reverso

# Criar arquivo de configuração do Nginx para o Airflow
sudo tee /etc/nginx/sites-available/airflow <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
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

# Ajustar as permissões do firewall para permitir tráfego na porta 80
# (Opcional: Se o UFW estiver instalado e ativo)
# sudo ufw allow 'Nginx Full'

sleep 10

# Iniciar o Airflow
sudo astro dev start

# Fim do script
