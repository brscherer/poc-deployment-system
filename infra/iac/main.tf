terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "infra" {
  metadata { name = "infra" }
}

resource "kubernetes_namespace" "apps" {
  metadata { name = "apps" }
}