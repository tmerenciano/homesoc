#!/bin/bash

# Script to debug the ELK (Elasticsearch, Logstash, and Kibana) stack

# Function to check container status
check_containers() {
  echo "Checking ELK containers status..."
  docker ps --filter "name=elasticsearch" --filter "name=logstash" --filter "name=kibana"
}

# Function to check Elasticsearch health
check_elasticsearch() {
  echo "Checking Elasticsearch health..."
  curl -X GET http://localhost:9200/_cluster/health?pretty || echo "Failed to connect to Elasticsearch."
}

# Function to fetch Elasticsearch logs
elasticsearch_logs() {
  echo "Fetching Elasticsearch logs..."
  docker logs elasticsearch --tail 50
}

# Function to check Logstash status
check_logstash() {
  echo "Checking Logstash logs for errors..."
  docker logs logstash --tail 50
}

# Function to check Kibana status
check_kibana() {
  echo "Checking Kibana logs for errors..."
  docker logs kibana --tail 50
}

# Function to verify Elasticsearch connection from Kibana
check_kibana_to_elasticsearch() {
  echo "Verifying Kibana connectivity to Elasticsearch..."
  docker exec kibana curl -X GET http://elasticsearch:9200/_cluster/health?pretty || echo "Kibana cannot reach Elasticsearch."
}

# Function to check disk usage
check_disk_usage() {
  echo "Checking disk usage for Docker volumes..."
  docker system df
}

# Menu for debugging options
while true; do
  echo "========================================="
  echo "             ELK Debugging Menu          "
  echo "========================================="
  echo "1. Check ELK container status"
  echo "2. Check Elasticsearch health"
  echo "3. Fetch Elasticsearch logs"
  echo "4. Fetch Logstash logs"
  echo "5. Fetch Kibana logs"
  echo "6. Verify Kibana to Elasticsearch connection"
  echo "7. Check Docker disk usage"
  echo "8. Exit"
  echo "========================================="

  read -p "Enter your choice [1-8]: " choice

  case $choice in
    1)
      check_containers
      ;;
    2)
      check_elasticsearch
      ;;
    3)
      elasticsearch_logs
      ;;
    4)
      check_logstash
      ;;
    5)
      check_kibana
      ;;
    6)
      check_kibana_to_elasticsearch
      ;;
    7)
      check_disk_usage
      ;;
    8)
      echo "Exiting debug script."
      exit 0
      ;;
    *)
      echo "Invalid option. Please choose a number between 1 and 8."
      ;;
  esac

done
