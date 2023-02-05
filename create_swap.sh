#!/bin/bash

echo "Check swap file"
if [ $(grep -c "swap" /proc/swaps) -eq 0 ]; then
  echo "Swapfile not found, creating a 2Gb file"
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  echo "Swapfile created"
else
  echo "Swapfile already exists"
fi