#!/bin/bash
sudo apt-get update
sudo apt-get install -y curl git python3-pip docker.io docker-compose nginx
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -LsfS https://get.airbyte.com | bash -

# Configurar o Nginx como proxy reverso

# Criar arquivo de configuração do Nginx para o Airflow
sudo tee /etc/nginx/sites-available/airflow <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8000;
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

sudo abctl local install --low-resource-mode --no-browser --insecure-cookies

gcloud pubsub topics publish vm-status-topic --message="VM $(hostname) pronta para uso às $(date)"
