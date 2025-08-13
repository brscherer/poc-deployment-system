resource "kind_cluster" "default" {
  name = "${var.prefix}poc-kind-cluster"
}

# Wait for all nodes to be ready before proceeding
resource "null_resource" "wait_for_cluster" {
  depends_on = [kind_cluster.default]

  provisioner "local-exec" {
        command = <<EOT
    if ! kubectl config current-context >/dev/null 2>&1; then
      echo "kubectl is not configured or context is not set"
      exit 1
    fi
    kubectl wait --for=condition=Ready nodes --all --timeout=120s
    EOT
  }
}

resource "kubernetes_namespace" "infra" {
  metadata { name = "infra" }
  depends_on = [null_resource.wait_for_cluster]
}

resource "kubernetes_namespace" "apps" {
  metadata { name = "apps" }
  depends_on = [null_resource.wait_for_cluster]
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "27.14.0"
  create_namespace = false

  depends_on = [null_resource.wait_for_cluster]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.0.0"
  create_namespace = false
  values = [
    file("${path.module}/values/grafana-values.yaml")
  ]
  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  depends_on = [null_resource.wait_for_cluster]
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.73"
  create_namespace = false
  values = [
    file("${path.module}/values/jenkins-values.yaml")
  ]

  depends_on = [null_resource.wait_for_cluster]
}
