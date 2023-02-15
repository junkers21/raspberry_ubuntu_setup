#!/bin/bash

curl -LJO https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/99-docker-tty.rules
sudo mv -f 99-docker-tty.rules /etc/udev/rules.d/99-docker-tty.rules

curl -LJO https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/docker_tty.sh
sudo chmod +x docker_tty.sh
sudo mv -f docker_tty.sh /usr/local/bin/docker_tty.sh