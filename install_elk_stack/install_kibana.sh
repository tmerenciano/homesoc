#!/bin/bash

# Met à jour les paquets et installe les prérequis
sudo apt update
sudo apt install -y apt-transport-https wget

# Ajoute la clé GPG de Kibana
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/kibana-keyring.gpg

# Ajoute le dépôt Kibana
echo "deb [signed-by=/usr/share/keyrings/kibana-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/kibana-8.x.list

# Installe Kibana
sudo apt update
sudo apt install -y kibana

# Active et démarre Kibana
sudo systemctl enable kibana
sudo systemctl start kibana

# Affiche l'état
sudo systemctl status kibana
