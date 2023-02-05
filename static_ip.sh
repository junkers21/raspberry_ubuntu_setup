#!/bin/bash

# Máscara de subred
mask="24"

# Gateway
gateway=$(ip -o -4 route show to default | awk '{print $3}')

# Obtener los octetos del gateway
IFS=. read -r a b c d <<< "$gateway"

# Calcular la dirección IP
ip="$a.$b.$c.$((d+1))"

# DNS
dns1="8.8.8.8"
dns2="8.8.4.4"

# Interfaz de red
interface=$(ip -o -4 route show to default | awk '{print $5}')

# Obtener la dirección IP actual
current_ip=$(ip addr show $interface | awk '/inet / {print $2}' | cut -d/ -f1)

# Comprobar si la dirección IP actual es válida
if [ -n "$current_ip" ]; then
  # Comprobar si la dirección IP actual está disponible
  if ping -c1 -W1 $current_ip > /dev/null 2>&1; then
    # Usar la dirección IP actual
    ip=$current_ip
  else
    # La dirección IP actual no está disponible
    # Incrementar la dirección IP inicial
    ip_array=(${ip//./ })
    ip_array[3]=$((ip_array[3]+1))
    ip="${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.${ip_array[3]}"
    
    # Comprobar si la dirección IP está disponible
    while ! ping -c1 -W1 $ip > /dev/null 2>&1; do
      # Incrementar la dirección IP
      ip_array=(${ip//./ })
      ip_array[3]=$((ip_array[3]+1))
      ip="${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.${ip_array[3]}"
    done
  fi
else
  # La dirección IP actual no es válida
  # Comprobar si la dirección IP está disponible
  while ! ping -c1 -W1 $ip > /dev/null 2>&1; do
    # Incrementar la dirección IP
    ip_array=(${ip//./ })
    ip_array[3]=$((ip_array[3]+1))
    ip="${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.${ip_array[3]}"
  done
fi

# Configurar la dirección IP en la interfaz
sudo netplan apply --debug <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: no
      addresses: [$ip/$mask]
      gateway4: $gateway
      nameservers:
        addresses: [$dns1, $dns2]
EOF