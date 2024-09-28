import os
import json
import requests
import base64
from google.cloud import secretmanager

def get_secret(secret_id):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{os.environ.get('GCP_PROJECT')}/secrets/{secret_id}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    secret = response.payload.data.decode("UTF-8")
    return secret

def trigger_airflow_sync(event, context):
    airflow_api_url = get_secret("airflow-api-url")
    airflow_username = get_secret("airflow-api-username")
    airflow_password = get_secret("airflow-api-password")

    # Codificar as credenciais em base64 para o header de Autenticação Básica
    credentials = f"{airflow_username}:{airflow_password}"
    encoded_credentials = base64.b64encode(credentials.encode()).decode()

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Basic {encoded_credentials}',
    }

    payload = {
        "conf": {}
    }

    response = requests.post(
        airflow_api_url,
        headers=headers,
        data=json.dumps(payload)
    )

    if response.status_code in [200, 201, 202]:
        print("DAG de sincronização acionada com sucesso.")
    else:
        print(f"Falha ao acionar DAG de sincronização: {response.text}")
        response.raise_for_status()
