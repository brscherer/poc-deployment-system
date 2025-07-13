run "namespaces_exist" {
  command = plan

  assert {
    condition     = kubernetes_namespace.infra.metadata[0].name == "infra"
    error_message = "Infra namespace should be created"
  }

  assert {
    condition     = kubernetes_namespace.apps.metadata[0].name == "apps"
    error_message = "Apps namespace should be created"
  }
}