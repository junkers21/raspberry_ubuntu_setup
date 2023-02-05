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
  echo "Docker installed"
fi