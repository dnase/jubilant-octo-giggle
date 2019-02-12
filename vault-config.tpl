ui = true
api_addr = "http://${vault_address}:8200"
cluster_addr = "http://${vault_address}:8201"
storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "${vault_address}:8201"
  tls_disable = true
#  tls_key_file  = "{{ssl_key_dir}}/server.key"
#  tls_cert_file = "{{ssl_cert_dir}}/server.crt"
}
