ui = true
api_addr = "http://$${NODE_IP}:8200"
cluster_addr = "http://$${NODE_IP}:8201"
storage "consul" {
  scheme        = "https"
  address       = "127.0.0.1:8501"
  path          = "vault/"
  tls_ca_file   = "/etc/consul.d/tls/consul-agent-ca.pem"
  tls_cert_file = "/etc/consul.d/tls/dc1-client-consul-0.pem"
  tls_key_file  = "/etc/consul.d/tls/dc1-client-consul-0-key.pem"
}

listener "tcp" {
  address            = "0.0.0.0:8200"
  cluster_address    = "$${NODE_IP}:8201"
  tls_disable        = false
  tls_client_ca_file = "/etc/consul.d/tls/consul-agent-ca.pem"
  tls_cert_file      = "/etc/vault.d/tls/dc1-server-vault-0.pem"
  tls_key_file       = "/etc/vault.d/tls/dc1-server-vault-0-key.pem"
}

seal "azurekeyvault" {
  tenant_id      = "${auto_tenant_id}"
  client_id      = "${auto_client_id}"
  client_secret  = "${auto_client_secret}"
  vault_name     = "${auto_vault_name}"
  key_name       = "${auto_key_name}"
}
