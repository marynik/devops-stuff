terraform {
  cloud {
    organization = "MaryNikOrg"
    workspaces {
      name = "learn-azure2"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.19.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.21.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = var.location
}

provider "kubernetes" {
  host                   = module.cluster.kube_config[0].host
  username               = module.cluster.kube_config[0].username
  password               = module.cluster.kube_config[0].password
  client_certificate     = base64decode(module.cluster.kube_config[0].client_certificate)
  client_key             = base64decode(module.cluster.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(module.cluster.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kube_config[0].host
    client_certificate     = base64decode(module.cluster.kube_config[0].client_certificate)
    client_key             = base64decode(module.cluster.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(module.cluster.kube_config[0].cluster_ca_certificate)
  }
}

