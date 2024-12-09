#!/bin/bash

# Répertoire de configuration de Logstash
PIPELINE_DIR="/etc/logstash/conf.d"
FILTERS_DIR="$PIPELINE_DIR/1_filters"

# Vérifie si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root ou avec sudo."
  exit 1
fi

# Création des fichiers et dossiers nécessaires
echo "Création de la structure de la pipeline Logstash..."

# Création du répertoire de la pipeline si non existant
if [ ! -d "$PIPELINE_DIR" ]; then
  echo "Création du répertoire $PIPELINE_DIR..."
  mkdir -p "$PIPELINE_DIR"
fi

# Création du dossier des filtres
if [ ! -d "$FILTERS_DIR" ]; then
  echo "Création du dossier des filtres : $FILTERS_DIR..."
  mkdir -p "$FILTERS_DIR"
fi

# Création du fichier 00_input.conf
echo "Création de 00_input.conf..."
cat > "$PIPELINE_DIR/00_input.conf" <<EOL
input {
  file {
    path => "/var/log/logstash_input.log"
    start_position => "beginning"
    sincedb_path => "/dev/null"
  }
}
EOL

# Création d'un exemple de filtre dans 1_filters/
echo "Création d'un exemple de filtre dans $FILTERS_DIR/example_filter.conf..."
cat > "$FILTERS_DIR/example_filter.conf" <<EOL
filter {
  grok {
    match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:log_level} %{GREEDYDATA:message}" }
  }
  date {
    match => ["timestamp", "ISO8601"]
  }
}
EOL

# Création du fichier 99_output.conf
echo "Création de 99_output.conf..."
cat > "$PIPELINE_DIR/99_output.conf" <<EOL
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
  stdout {
    codec => rubydebug
  }
}
EOL

# Affichage des fichiers créés
echo "Structure de la pipeline créée :"
echo "- $PIPELINE_DIR/00_input.conf"
echo "- $FILTERS_DIR/example_filter.conf"
echo "- $PIPELINE_DIR/99_output.conf"

# Redémarrage de Logstash pour appliquer la configuration
read -p "Souhaitez-vous redémarrer Logstash maintenant ? (y/n): " restart
if [ "$restart" = "y" ]; then
  echo "Redémarrage de Logstash..."
  systemctl restart logstash
  echo "Logstash redémarré."
else
  echo "Veuillez redémarrer Logstash manuellement pour appliquer les changements."
fi

#Pour tester :
#echo "2023-12-09 INFO This is a test log entry" >> /var/log/logstash_input.log
#sudo systemctl restart logstash sudo journalctl -fu logstash 

