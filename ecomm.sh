#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo rm -rt /var/www/html/*
sudo git clone https://github.com/Aditya3255/ecomm.git /var/www/html
