#!/bin/bash

sudo apt-get update 
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt install net-tools -y

#TODO: Add 2G swap 
#TODO: Install docker
#TODO: Setup static IP on start