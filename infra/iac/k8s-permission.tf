resource "kubernetes_service_account" "jenkins_sa" {
  metadata {
    name      = "jenkins-sa"
    namespace = "infra"
  }
}

resource "kubernetes_cluster_role" "jenkins_cluster_admin" {
  metadata {
    name = "jenkins-cluster-admin"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_cluster_admin_binding" {
  metadata {
    name = "jenkins-cluster-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.jenkins_cluster_admin.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_sa.metadata[0].name
    namespace = kubernetes_service_account.jenkins_sa.metadata[0].namespace
  }
}