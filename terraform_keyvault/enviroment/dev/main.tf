module "resource_group" {
  source = "../../module/azurerm_resource_group"
  resource_groups = {
    dev_rg = {
      name     = "dev_rg"
      location = "east us"
    }
  }
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../module/azurerm_virtual_network"
  virtual_networks = {
    dev_vnet = {
      name                = "dev_vnet"
      location            = "east us"
      resource_group_name = "dev_rg"
      address_space       = ["10.0.0.0/16"]
    }
  }
}

module "subnet" {
  depends_on = [module.virtual_network]
  source     = "../../module/azurerm_subnet"
  subnets = {
    dev_subnet = {
      name                 = "dev_subnet"
      resource_group_name  = "dev_rg"
      virtual_network_name = "dev_vnet"
      address_prefixes     = ["10.0.1.0/24"]

    }
    bastion_subnet = {
      name                 = "AzureBastionSubnet"
      resource_group_name  = "dev_rg"
      virtual_network_name = "dev_vnet"
      address_prefixes     = ["10.0.2.0/24"]
    }
  }
}

module "bastion" {
  depends_on = [module.subnet]
  source     = "../../module/azurerm_bastion"
  bastions = {
    dev = {
      bastion_name         = "dev_bastion"
      resource_group_name  = "dev_rg"
      location             = "east us"
      virtual_network_name = "dev_vnet"
      name                 = "AzureBastionSubnet"
      public_ip_name       = "dev_bastion_pip"
    }
  }

}

module "vm" {
  depends_on = [module.subnet]
  source     = "../../module/azurerm_virtual_machine"
  virtual_machines = {
    dev = {
      vm_name             = "dev-vm"
      location            = "east us"
      resource_group_name = "dev_rg"
      virtual_network_name = "dev_vnet"
      subnet_name         = "dev_subnet"
      nic_name            = "dev_nic"
      vm_size             = "Standard_D2ads_v6"
    }
  }

}

