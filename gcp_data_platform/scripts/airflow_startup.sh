#!/bin/bash

# Atualizar pacotes e instalar dependências
sudo apt-get update

# Instalar pacotes necessários
sudo apt-get install -y curl git python3-pip docker.io docker-compose

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
sudo astro dev init

# Instalar o Cosmos e dependências do dbt
echo "astronomer-cosmos==1.6.0" >> requirements.txt
echo "dbt-core==1.8.7" >> requirements.txt
echo "dbt-bigquery==1.8.2" >> requirements.txt

# Construir a imagem Docker com as novas dependências
sudo astro dev docker-build

# Iniciar o Airflow em modo detached
sudo astro dev start -d
