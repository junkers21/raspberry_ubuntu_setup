#!/bin/bash

# Verificar si Docker está instalado
if command -v docker > /dev/null 2>&1; then
  echo "Docker está instalado"
else
  echo "Docker no está instalado, iniciando la instalación"

  # Instalar Docker a través de la solución proporcionada por Docker
  curl -sSL https://get.docker.com | sh

  # Agregar el usuario actual al grupo de Docker
  sudo usermod -aG docker $USER
fi