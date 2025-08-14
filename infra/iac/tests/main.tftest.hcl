variables {
  prefix = "test-"
  ghcr_token = "ghp_xxxxxxx"
  jenkins_admin_password = "foo"
}

run "namespace_infra" {
  assert {
    condition     = kubernetes_namespace.infra.metadata[0].name == "infra"
    error_message = "Namespace 'infra' was not created"
  }
}

run "namespace_apps" {
  assert {
    condition     = kubernetes_namespace.apps.metadata[0].name == "apps"
    error_message = "Namespace 'apps' was not created"
  }
}


run "prometheus_helm" {
  assert {
    condition     = helm_release.prometheus.name == "prometheus"
    error_message = "Prometheus Helm release was not applied correctly"
  }

  assert {
    condition     = helm_release.prometheus.namespace == "infra"
    error_message = "Prometheus Helm release is not in the 'infra' namespace"
  }
}


run "grafana_helm" {
  assert {
    condition     = helm_release.grafana.name == "grafana"
    error_message = "Grafana Helm release was not applied correctly"
  }

  assert {
    condition     = helm_release.grafana.namespace == "infra"
    error_message = "Grafana Helm release is not in the 'infra' namespace"
  }
}