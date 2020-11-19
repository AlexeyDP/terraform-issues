provider "local" {
  version = "~> 2.0.0"
}

provider "azurerm" {
  version         = "~> 2.33.0"
  features {}
}

provider "random" {
  version = "~> 3.0.0"
}

provider "kubernetes" {
   version = "1.13.0"
}

provider "tls" {
   version = "~> 3.0.0"
}