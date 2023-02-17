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
# Verificar si la interfaz es inalámbrica
if [[ $interface == "w"* ]]; then
  echo "La interfaz es inalámbrica, por lo que no se configurará la dirección IP estática."
  exit
fi

# Obtener la dirección IP actual
current_ip=$(ip addr show $interface | awk '/inet / {print $2}' | cut -d/ -f1)

# Comprobar si la dirección IP actual es válida
if [ -n "$current_ip" ]; then
  # Comprobar si la dirección IP actual está disponible
  if ping -c1 -W1 $current_ip > /dev/null 2>&1; then
    # Comprobar si la dirección IP actual está en el rango 100-255
    IFS=. read -r a b c d <<< "$current_ip"
    if [ "$d" -ge 100 ] && [ "$d" -le 255 ]; then
      # Usar la dirección IP actual
      ip=$current_ip
    fi
  fi
fi

# Si la dirección IP actual no es válida o no está en el rango 100-255
if [ "$d" -lt 100 ] || [ "$d" -gt 255 ]; then
  # Incrementar la dirección IP inicial
  ip_array=(${ip//./ })
  ip_array[3]=$((ip_array[3]+1))
  ip="${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.${ip_array[3]}"

  # Comprobar si la dirección IP está en el rango 100-255
  IFS=. read -r a b c d <<< "$ip"
  while [ "$d" -lt 100 ] || [ "$d" -gt 255 ]; do
    # Incrementar la dirección IP
    ip_array=(${ip//./ })
    ip_array[3]=$((ip_array[3]+1))
    ip="${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.${ip_array[3]}"
    IFS=. read -r a b c d <<< "$ip"
  done
fi

# Configurar la dirección IP en la interfaz
echo "network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: no
      addresses: [$ip/$mask]
      gateway4: $gateway
      nameservers:
        addresses: [$dns1, $dns2]" > /etc/netplan/01-netcfg.yaml
sudo rm -f /etc/netplan/50-cloud-init.yaml
sudo netplan apply --debug