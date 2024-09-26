Inicializado o projeto com poetry
- `poetry new liti_case_analytics_engineer`
- `cd liti_case_analytics_engineer`
- `code .`

Criado o ambiente virtual local
- `poetry env use 3.11.5`
- `poetry shell`

Criado o repositório git local
- `git init`
- `git add .`
- `git commit -m "first commit"`

Criada a pasta gcp_data_platform, onde vai conter o projeto da infraestrutura
- `mkdir gcp_data_platform`
- `cd gcp_data_platform`
- `mkdir scripts`

Criado os arquivos terraform contendo todos os recursos que serão utilizados do GCP
```
|-- gcp_data_platform
|   |-- airbyte_compute.tf
|   |-- airflow_compute.tf
|   |-- bigquery.tf
|   |-- compute.tf
|   |-- database.tf
|   |-- firewall.tf
|   |-- iam.tf
|   |-- main.tf
|   |-- metabase_compute.tf
|   |-- networks.tf
|   |-- outputs.tf
|   |-- postgres.tf
|   |-- scripts
|   |   |-- airbyte_startup.sh
|   |   |-- airflow_startup.sh
|   |   `-- metabase_startup.sh
|   |-- storage.tf
|   |-- users.tf
|   `-- variables.tf
```
Ajuste no .gitignore, removendo o variables.tf, e arquivos *.exe (evitar o upload do terraform providers)

Segundo commit
- `git add .`
- `git commit -m "[build] terraform"`