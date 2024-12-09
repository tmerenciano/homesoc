#Crée ou modifie les fichiers YAML correspondants dans les répertoires par défaut.
#Ajoute des valeurs par défaut si l'utilisateur ne fournit pas d'entrée.
#Facilite l'édition des configurations sans nécessiter de connaissance approfondie des fichiers YAML.

#!/bin/bash

# Fonction pour configurer Elasticsearch
config_elasticsearch() {
    CONFIG_FILE="/etc/elasticsearch/elasticsearch.yml"

    echo "=== Configuration d'Elasticsearch ==="
    read -p "Nom du cluster (par défaut: my-cluster): " cluster_name
    cluster_name=${cluster_name:-my-cluster}

    read -p "Chemin des données (par défaut: /var/lib/elasticsearch): " data_path
    data_path=${data_path:-/var/lib/elasticsearch}

    read -p "Chemin des logs (par défaut: /var/log/elasticsearch): " log_path
    log_path=${log_path:-/var/log/elasticsearch}

    read -p "Adresse réseau (par défaut: 0.0.0.0): " network_host
    network_host=${network_host:-0.0.0.0}

    echo "Écriture dans $CONFIG_FILE..."
    sudo tee $CONFIG_FILE > /dev/null <<EOL
cluster.name: $cluster_name
path.data: $data_path
path.logs: $log_path
network.host: $network_host
EOL
    echo "Configuration d'Elasticsearch mise à jour."
}

# Fonction pour configurer Logstash
config_logstash() {
    CONFIG_FILE="/etc/logstash/logstash.yml"

    echo "=== Configuration de Logstash ==="
    read -p "Mode pipeline (true/false, par défaut: false): " pipeline_mode
    pipeline_mode=${pipeline_mode:-false}

    read -p "Chemin du pipeline (par défaut: /etc/logstash/conf.d): " pipeline_path
    pipeline_path=${pipeline_path:-/etc/logstash/conf.d}

    echo "Écriture dans $CONFIG_FILE..."
    sudo tee $CONFIG_FILE > /dev/null <<EOL
pipeline.batch.size: 125
pipeline.workers: 2
path.config: $pipeline_path
config.reload.automatic: $pipeline_mode
EOL
    echo "Configuration de Logstash mise à jour."
}

# Fonction pour configurer Kibana
config_kibana() {
    CONFIG_FILE="/etc/kibana/kibana.yml"

    echo "=== Configuration de Kibana ==="
    read -p "URL du serveur Elasticsearch (par défaut: http://localhost:9200): " elasticsearch_url
    elasticsearch_url=${elasticsearch_url:-http://localhost:9200}

    read -p "Hôte du serveur Kibana (par défaut: 0.0.0.0): " server_host
    server_host=${server_host:-0.0.0.0}

    read -p "Port du serveur Kibana (par défaut: 5601): " server_port
    server_port=${server_port:-5601}

    echo "Écriture dans $CONFIG_FILE..."
    sudo tee $CONFIG_FILE > /dev/null <<EOL
elasticsearch.hosts: ["$elasticsearch_url"]
server.host: "$server_host"
server.port: $server_port
EOL
    echo "Configuration de Kibana mise à jour."
}

# Menu principal
echo "=== Script interactif de configuration Elastic Stack ==="
echo "1. Configurer Elasticsearch"
echo "2. Configurer Logstash"
echo "3. Configurer Kibana"
echo "4. Quitter"
read -p "Choisissez une option (1-4): " option

case $option in
    1)
        config_elasticsearch
        ;;
    2)
        config_logstash
        ;;
    3)
        config_kibana
        ;;
    4)
        echo "Quitter le script."
        exit 0
        ;;
    *)
        echo "Option invalide. Veuillez réessayer."
        ;;
esac
