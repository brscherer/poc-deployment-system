terraform {
  required_providers {
    minikube = {
      source = "scott-the-programmer/minikube"
      version = "0.5.0"
    }
  }
}

provider "minikube" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
