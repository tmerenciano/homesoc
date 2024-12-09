#!/bin/bash

# Met à jour les paquets et installe les prérequis
sudo apt update
sudo apt install -y apt-transport-https openjdk-11-jre wget

# Ajoute la clé GPG de Logstash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/logstash-keyring.gpg

# Ajoute le dépôt Logstash
echo "deb [signed-by=/usr/share/keyrings/logstash-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/logstash-8.x.list

# Installe Logstash
sudo apt update
sudo apt install -y logstash

# Active et démarre Logstash
sudo systemctl enable logstash
sudo systemctl start logstash

# Affiche l'état
sudo systemctl status logstash
