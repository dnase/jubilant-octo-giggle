#!/bin/bash

# Get private ip address of node
readonly NODE_IP="$(/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')"

# Update hosts
sudo echo '${lb_ip} ${lb_fqdn}' >> /etc/hosts

# Copy consul config
sudo cat << EOF > /etc/consul.d/server/consul.hcl
${consul_config_contents}
EOF

# Get ca files from Azure Key Vault
tenant_id="${tenant_id}"
subscription_id="${subscription_id}"
client_id="${client_id}"
client_secret='${client_secret}'
akv_name="${akv_name}"
akv_tls="${akv_tls}"
akv_tls_key="${akv_tls_key}"
az login --service-principal -u "$${client_id}" -p "$${client_secret}" --tenant "$${tenant_id}"
az keyvault secret show -n $${akv_tls} --vault-name $${akv_name} --query value -o tsv > /etc/consul.d/tls/$${akv_tls}.pem
az keyvault secret show -n $${akv_tls_key} --vault-name $${akv_name} --query value -o tsv > /etc/consul.d/tls/$${akv_tls_key}.pem

# Create cert for this node
cd /etc/consul.d/tls
sudo consul tls cert create -ca=$${akv_tls}.pem -key=$${akv_tls_key}.pem -dc=dc1 -domain=consul -server

# Start/Enable services
sudo systemctl enable consul-server.service
sudo systemctl start consul-server.service
