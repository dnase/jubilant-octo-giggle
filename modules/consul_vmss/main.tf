resource "azurerm_virtual_machine_scale_set" "module" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  name                = "${local.vmss_name}"
  upgrade_policy_mode = "Manual"

  sku {
    name     = "${var.size}"
    tier     = "${var.tier}"
    capacity = "${var.count}"
  }

  os_profile {
    computer_name_prefix = "${local.module_name}vm"
    admin_username       = "${var.username}"
    custom_data          = "${data.template_file.consul-install.rendered}"
  }

  # MSI creation 
  identity {
    type = "SystemAssigned"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = "${var.public_key_openssh}"
    }
  }

  network_profile {
    name    = "${local.module_name}networkProfile"
    primary = true

    ip_configuration {
      primary                                = true
      name                                   = "${local.module_name}ipConfig"
      subnet_id                              = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.consul_bepool.id}"]

      // load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.consul_lbnatpool.*.id, count.index)}"]
    }
  }

  storage_profile_image_reference {
    id = "${var.os_image_id}"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    os_type           = "Linux"
    managed_disk_type = "Standard_LRS"
  }

  tags = "${var.tags}"
}

data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "primary" {}

# Give MSI access to read the resource group
resource "azurerm_role_assignment" "module" {
  role_definition_name = "Reader"
  principal_id         = "${azurerm_virtual_machine_scale_set.module.identity.0.principal_id}"
  scope                = "${data.azurerm_subscription.primary.id}/resourceGroups/${var.resource_group_name}"
}
