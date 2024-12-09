#!/bin/bash

# Met à jour les paquets et installe les prérequis
sudo apt update
sudo apt install -y apt-transport-https ca-certificates wget

# Ajoute la clé GPG d'Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

# Ajoute le dépôt Elasticsearch
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elasticsearch-8.x.list

# Installe Elasticsearch
sudo apt update
sudo apt install -y elasticsearch

# Active et démarre Elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Affiche l'état
sudo systemctl status elasticsearch
