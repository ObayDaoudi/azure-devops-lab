terraform {
  backend "azurerm" {
    resource_group_name  = "devops-lab-rg"
    storage_account_name = "devoplabstateob"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
