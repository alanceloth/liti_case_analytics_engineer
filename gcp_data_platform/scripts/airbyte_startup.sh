#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker run --restart unless-stopped -d -p 8000:8000 airbyte/airbyte:latest
