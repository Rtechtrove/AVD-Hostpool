resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                = var.host_pool_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Pooled"
  load_balancer_type  = "BreadthFirst"
  preferred_app_group_type = "Desktop"
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registration" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = timeadd(timestamp(), "24h")
}

resource "azurerm_windows_virtual_machine" "session_host" {
  count               = var.session_host_count
  name                = "avd-vm-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "ChangeMe123!"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}    sku       = "20h2-evd"
    version   = "latest"
  }

resource "azurerm_network_interface" "nic" {
  count               = var.session_host_count
  name                = "avd-nic-${count.index}"
  location            = var.location
}