resource "azurerm_resource_group" "atosk8s" {
  name     = "${var.prefix}-k8s-resources"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "atosk8s" {
  name                = "${var.prefix}-k8s"
  location            = "${azurerm_resource_group.atosk8s.location}"
  resource_group_name = "${azurerm_resource_group.atosk8s.name}"
  dns_prefix          = "${var.prefix}-k8s"

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.kubernetes_client_id}"
    client_secret = "${file("..\\azure-secret.txt")}"
  }

  tags = {
    Environment = "Dev"
  }
}