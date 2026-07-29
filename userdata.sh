#!/bin/bash
apt -y update
apt -y install apache2
echo "HELLO from Bastion: $(hostname -f)" > /var/www/html/index.html
systemctl start apache2
systemctl enable apache2