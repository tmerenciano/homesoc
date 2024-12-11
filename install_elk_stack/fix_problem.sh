sudo apt-get update
sudo apt-get install -y ca-certificates
sudo update-ca-certificates

sudo mkdir -p /etc/docker/certs.d/docker.elastic.co
sudo cp /etc/ssl/certs/ca-certificates.crt /etc/docker/certs.d/docker.elastic.co/ca.crt

sudo systemctl restart docker

cat <<EOL > /etc/docker/daemon.json
{
    "insecure-registries": ["docker.elastic.co"]
}
EOL

sudo systemctl restart docker
docker-compose up -d
