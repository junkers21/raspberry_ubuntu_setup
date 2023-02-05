#!/bin/bash

if test -f "/usr/local/bin/static_ip"; then
    echo "Ip fixing cron already setted"
else
    echo "Setting up Ip fixing cron on reboot"

    curl -LJO https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/static_ip.sh
    sudo chmod +x static_ip.sh
    sudo mv static_ip.sh /usr/local/bin/static_ip

    echo "Adding file to reboot cron"
    (crontab -l ; echo "@reboot bash /usr/local/bin/static_ip") | crontab -

    echo "Executing for the first time"
    sudo bash /usr/local/bin/static_ip
    echo "Ip fixed"
fi