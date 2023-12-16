#!/bin/bash

# Store the IP address in a variable
read -p "Enter the IP address: " ip
ip_address="$ip"

# Store the port number in a variable
read -p "Enter the port number: " port
port_number="$port"

##########################################################################
# 1. Install the libapache2-mod-jk package                               #
# 2. Enable the module                                                   #
# 3. Create the configuration file pointing to the target AJP-Proxy port #
##########################################################################

sudo apt install libapache2-mod-jk
sudo a2enmod proxy_ajp
sudo a2enmod proxy_http
export TARGET="$ip_address"
echo -n """<Proxy *>
Order allow,deny
Allow from all
</Proxy>
ProxyPass / ajp://$TARGET:$port_number/
ProxyPassReverse / ajp://$TARGET:$port_number/""" | sudo tee /etc/apache2/sites-available/ajp-proxy.conf

sudo ln -s /etc/apache2/sites-available/ajp-proxy.conf /etc/apache2/sites-enabled/ajp-proxy.conf

sudo systemctl start apache2

echo "\nIf it is necessary to update the localhost port number used, it can be edited in /etc/apache2/ports.conf\n"

echo "\nDon't forget to curl the configured http://127.0.0.1 port to test the connection\n"
