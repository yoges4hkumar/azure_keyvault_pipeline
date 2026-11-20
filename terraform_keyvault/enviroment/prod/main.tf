module "resource_group" {
  source = "../../module/azurerm_resource_group"
  resource_groups = {
    prod_rg = {
      name     = "prod_rg"
      location = "east us"
    }
  }
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../module/azurerm_virtual_network"
  virtual_networks = {
    prod_vnet = {
      name                = "prod_vnet"
      location            = "east us"
      resource_group_name = "prod_rg"
      address_space       = ["10.0.0.0/16"]
    }
  }
}

module "subnet" {
  depends_on = [module.virtual_network]
  source     = "../../module/azurerm_subnet"
  subnets = {
    prod_subnet = {
      name                 = "prod_subnet"
      resource_group_name  = "prod_rg"
      virtual_network_name = "prod_vnet"
      address_prefixes     = ["10.0.1.0/24"]

    }
    bastion_subnet = {
      name                 = "AzureBastionSubnet"
      resource_group_name  = "prod_rg"
      virtual_network_name = "prod_vnet"
      address_prefixes     = ["10.0.2.0/24"]
    }
  }
}

module "bastion" {
  depends_on = [module.subnet]
  source     = "../../module/azurerm_bastion"
  bastions = {
    prod = {
      bastion_name         = "prod_bastion"
      resource_group_name  = "prod_rg"
      location             = "east us"
      virtual_network_name = "prod_vnet"
      name                 = "AzureBastionSubnet"
      public_ip_name       = "prod_bastion_pip"
    }
  }

}

module "vm" {
  depends_on = [module.subnet]
  source     = "../../module/azurerm_virtual_machine"
  virtual_machines = {
    prod = {
      vm_name             = "prod-vm"
      location            = "east us"
      resource_group_name = "prod_rg"
      virtual_network_name = "prod_vnet"
      subnet_name         = "prod_subnet"
      nic_name            = "prod_nic"
      vm_size             = "Standard_D2ads_v6"
    }
  }

}

