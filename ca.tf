# Save local ca files to Azure Key Vault
resource "azurerm_key_vault_secret" "ca" {
  name         = "consul-agent-ca"
  value        = "${file("./tls-ca/consul-agent-ca.pem")}"
  key_vault_id = "${module.core.keyvault_id}"
}

resource "azurerm_key_vault_secret" "ca-key" {
  name         = "consul-agent-ca-key"
  value        = "${file("./tls-ca/consul-agent-ca-key.pem")}"
  key_vault_id = "${module.core.keyvault_id}"
}
