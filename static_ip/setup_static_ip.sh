#!/bin/bash


curl -LJO https://raw.githubusercontent.com/junkers21/raspberry_ubuntu_setup/main/static_ip/static_ip.sh
sudo chmod +x static_ip.sh

if test -f "/usr/local/bin/static_ip"; then
    echo "Ip fixing cron already setted"
    echo "Upgrading file"

    sudo mv -f static_ip.sh /usr/local/bin/static_ip
else
    echo "Setting up Ip fixing cron on reboot"
    
    sudo mv static_ip.sh /usr/local/bin/static_ip

    echo "Adding file to reboot cron"
    (crontab -l ; echo "@reboot bash /usr/local/bin/static_ip") | crontab -
fi

echo "Fixing IP"
sudo bash /usr/local/bin/static_ip
echo "Ip fixed"