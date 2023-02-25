#!/bin/bash

echo "Check Docker installation"
if command -v docker > /dev/null 2>&1; then
  echo "Docker already installed"
else
  echo "Docker not installed, starting setup"

  # Instalar Docker a través de la solución proporcionada por Docker
  curl -sSL https://get.docker.com | sh

  # Agregar el usuario actual al grupo de Docker
  sudo usermod -aG docker $USER
  newgrp docker

  sudo apt install docker-compose -y

  sudo docker pull portainer/portainer-ce:linux-arm64
  sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:linux-arm64

  echo "Docker installed"
fi