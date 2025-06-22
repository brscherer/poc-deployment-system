provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }
}

resource "kubernetes_namespace" "infra" {
  metadata {
    name = "infra"
  }
}