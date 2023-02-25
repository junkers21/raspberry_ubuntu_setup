#!/bin/bash

sudo apt-get update 
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt install net-tools -y
sudo apt install wireless-tools -y
sudo apt install iw -y

# Add 2G swap 
wget -O - https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/swap/create_swap.sh | bash

# Install docker
wget -O - https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/docker/docker_install.sh | bash

# Setup static IP on start
wget -O - https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/static_ip/setup_static_ip.sh | bash

# Setup usb update
wget -O - https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/update_usb/setup_usb_update.sh | bash