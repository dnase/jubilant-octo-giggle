resource "azurerm_lb" "consul_access" {
  name                = "${local.module_name}_access"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                          = "consulIPConfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${var.subnet_id}"
  }
}

// resource "azurerm_lb_nat_pool" "consul_lbnatpool" {
//   resource_group_name            = "${var.resource_group_name}"
//   name                           = "ssh"
//   loadbalancer_id                = "${azurerm_lb.consul_access.id}"
//   protocol                       = "Tcp"
//   frontend_port_start            = 2200
//   frontend_port_end              = 2299
//   backend_port                   = 22
//   frontend_ip_configuration_name = "PublicIPAddress"
// }

// resource "azurerm_lb_nat_pool" "consul_lbnatpool_rpc" {
//   resource_group_name            = "${var.resource_group_name}"
//   name                           = "rpc"
//   loadbalancer_id                = "${azurerm_lb.consul_access.id}"
//   protocol                       = "Tcp"
//   frontend_port_start            = 8300
//   frontend_port_end              = 8399
//   backend_port                   = 8300
//   frontend_ip_configuration_name = "PublicIPAddress"
// }

// resource "azurerm_lb_nat_pool" "consul_lbnatpool_http" {
//   resource_group_name            = "${var.resource_group_name}"
//   name                           = "http"
//   loadbalancer_id                = "${azurerm_lb.consul_access.id}"
//   protocol                       = "Tcp"
//   frontend_port_start            = 8500
//   frontend_port_end              = 8500
//   backend_port                   = 8500
//   frontend_ip_configuration_name = "consulIPConfig"
// }
// resource "azurerm_lb_nat_pool" "consul_lbnatpool_https" {
//   resource_group_name            = "${var.resource_group_name}"
//   name                           = "https"
//   loadbalancer_id                = "${azurerm_lb.consul_access.id}"
//   protocol                       = "Tcp"
//   frontend_port_start            = 8500
//   frontend_port_end              = 8501
//   backend_port                   = 8501
//   frontend_ip_configuration_name = "consulIPConfig"
// }

resource "azurerm_lb_nat_rule" "lb_https" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.consul_access.id}"
  name                           = "https"
  protocol                       = "Tcp"
  frontend_port                  = 8501
  backend_port                   = 8501
  frontend_ip_configuration_name = "consulIPConfig"
}

resource "azurerm_lb_backend_address_pool" "consul_bepool" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.consul_access.id}"
  name                = "BackEndAddressPool"
}

// resource "azurerm_lb_probe" "test" {
//   resource_group_name =  "${var.resource_group_name}"
//   loadbalancer_id     = "${azurerm_lb.consul_access.id}"
//   name                = "consul-health-probe"
//   port                = 22
//  /v1/sys/health
// }

