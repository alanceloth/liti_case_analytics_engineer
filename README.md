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

Validado a conexão do terraform com minha conta no GCP e instalado o provider do google
- `terraform init`
- `gcloud init`
- `gcloud auth application-default login`

Ajuste no .gitignore, removendo o variables.tf, e arquivos *.exe (evitar o upload do terraform providers)

Subir a infraestrutura usando terraform
- `terraform plan`
- `terraform apply`

Para testar se a conexão ssh está funcionando
- `gcloud compute ssh <nome-da-instancia>`

Conectar no Airflow usando a porta 80
- `http://<ip externo>:80`

Conectar no Airbyte usando a porta 80
- `http://<ip externo>:80`

No Airbyte, configurar a Source
- Sources
- GCS
- Nome `GCS_filedump`
- Inserir os dados da Service Account
- Nome do bucket de origem `liti_case_analytics_engineer_filedump`

Adicionar os Streams abaixo na Source
- Formato `CSV`
- Nome `Customer`
- Input Schema
    ```
    {   "CustomerId": "string",   "customerGender": "string",   "customerHeight": "number",   "customerBirthDate": "string",   "originChannelGroup": "string",   "customerPlan": "string",   "activePlan": "string",   "isActive": "boolean",   "isActivePaid": "boolean",   "firstStartDate": "string",   "acquiredDate": "string",   "firstPaymentDate": "string",   "lastChargePaidDate": "string",   "churnDate": "string",   "customerInOnboarding": "boolean",   "customerDoctor": "string",   "customerNutritionist": "string",   "customerBesci": "string",   "customerCreatedAt": "string" }
    ```

- Formato `CSV`
- Nome `Customer Meal Plan`
- Input Schema
    ```
    {   "_id": "string",   "customerId": "string",   "staffId": "string",   "mealPlanId": "string",   "startDate": "string",   "endDate": "string",   "restrictions.gluten": "boolean",   "restrictions.lactose": "boolean",   "restrictions.vegan": "boolean",   "restrictions.ovolacto": "boolean",   "restrictions.highFodMaps": "boolean",   "createdAt": "string" }
    ```

- Formato `CSV`
- Nome `Customer Medicines Prescriptions`
- Input Schema
    ```
    {   "_id": "string",   "customerId": "string",   "staffId": "string",   "medicineId": "string",   "dosage": "string",   "description": "string",   "createdAt": "string",   "updatedAt": "string" }
    ```

- Formato `CSV`
- Nome `Customer Objectives`
- Input Schema
    ```
    {   "_id": "string",   "customerId": "string",   "staffId": "string",   "objective": "string",   "startDate": "string",   "createdAt": "string",   "updatedAt": "string" }
    ```

- Formato `CSV`
- Nome `Meal Plans`
- Input Schema
    ```
    {   "_id": "string",   "name": "string",   "group": "string",   "createdAt": "string" }
    ```

- Formato `CSV`
- Nome `Medicines`
- Input Schema
    ```
    {   "_id": "string",   "name": "string",   "type": "string",   "dosages[0]": "string",   "dosages[1]": "string",   "dosages[2]": "string",   "dosages[3]": "string",   "dosages[4]": "string",   "dosages[5]": "string",   "dosages[6]": "string",   "dosages[7]": "string",   "label": "string",   "deletedAt": "string" }
    ```


- Formato `CSV`
- Nome `Objectives`
- Input Schema
    ```
    {   "_id": "string",   "name": "string",   "description": "string",   "entity": "string",   "key": "string",   "display": "string",   "objective": "string",   "displayUnit": "string",   "type": "string" }
    ```


Configurar um Destino
Conector `GCS`
Nome `Google Cloud Storage (GCS)`
Autenticação:
- Na tela de buckets, ir em `Configurações`, `Interoperabilidade`, e gerar uma chave HMAC para a conta de serviço.
- Preencher os dados dela no conector
Configurar o destino `data-lake-bucket-liti-case-analytics-engineer`
Path `raw/`
Output format `CSV`
Normalização `Root level flattening`

Configurar o schema

Realizar o Sync

Os dados vão aparecer no bucket de destino, conferir.