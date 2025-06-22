provider "kubernetes" {}

resource "kubernetes_namespace" "infra" {
  metadata {
    name = var.infra_namespace
  }
}

resource "kubernetes_namespace" "apps" {
  metadata {
    name = var.app_namespace
  }
}

resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = var.infra_namespace
  }

  data = {
    "dashboard.json" = file("${path.module}/dashboards/sample-dashboard.json")
  }
}
