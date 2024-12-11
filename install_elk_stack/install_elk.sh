#!/bin/bash

# This script sets up the ELK (Elasticsearch, Logstash, and Kibana) stack using Docker.
# Ensure Docker and Docker Compose are installed before running this script.

set -e  # Exit immediately if a command exits with a non-zero status.

# Define Docker Compose YAML content for the ELK stack.
cat <<EOL > docker-compose.yml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.10.2
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - es_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    restart: always
    networks:
      - elk

  logstash:
    image: docker.elastic.co/logstash/logstash:8.10.2
    container_name: logstash
    ports:
      - "5044:5044"
      - "9600:9600"
    restart: always
    networks:
      - elk
    volumes:
      - ./logstash/config:/usr/share/logstash/config

  kibana:
    image: docker.elastic.co/kibana/kibana:8.10.2
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    restart: always
    depends_on:
      - elasticsearch
    networks:
      - elk

volumes:
  es_data:
    driver: local

networks:
  elk:
    driver: bridge
EOL

# Create configuration folder for Logstash
mkdir -p logstash/config

# Create a basic Logstash pipeline configuration
cat <<EOL > logstash/config/logstash.conf
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
}
EOL

# Provide feedback to the user
echo "Starting the ELK stack using Docker Compose..."

# Start the ELK stack using Docker Compose
docker-compose up -d

# Wait for Elasticsearch to start and generate the enrollment token
echo "Waiting for Elasticsearch to generate the enrollment token..."
sleep 30  # Adjust the sleep time based on your system's performance

enrollment_token=$(docker exec elasticsearch /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana)

# Save the enrollment token to a file
echo "Saving the enrollment token to enrollment_token.txt..."
echo "$enrollment_token" > enrollment_token.txt
cat enrollment_token.txt

# Get Kibana verification code
echo "Fetching the Kibana verification code..."
kibana_verification_code=$(docker exec kibana /usr/share/kibana/bin/kibana-verification-code)

# Save the verification code to a file
echo "Saving the Kibana verification code to kibana_verification_code.txt..."
echo "$kibana_verification_code" > kibana_verification_code.txt
cat kibana_verification_code.txt

# Provide instructions for the user
echo "The ELK stack is starting. Access Kibana at http://localhost:5601."
echo "Ensure Elasticsearch is reachable at http://localhost:9200."
echo "Logstash is ready to accept inputs on port 5044."
echo "The Kibana enrollment token has been saved to enrollment_token.txt."
echo "The Kibana verification code has been saved to kibana_verification_code.txt."
