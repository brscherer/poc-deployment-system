resource "kubernetes_secret" "ghcr" {
  metadata {
    name      = "jenkins-ghcr-secret"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }

  data = {
    username = var.ghcr_username
    token    = var.ghcr_token
  }

  type = "Opaque"
}

resource "kubernetes_secret" "jenkins_admin" {
  metadata {
    name      = "jenkins-admin-secret"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }

  data = {
    username = "admin"
    password = var.jenkins_admin_password
  }

  type = "Opaque"
}