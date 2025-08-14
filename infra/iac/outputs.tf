output "cluster_name" {
  description = "Name of the Kind cluster"
  value       = kind_cluster.default.name
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = kind_cluster.default.kubeconfig_path
  sensitive   = true
}

output "grafana_port_forward" {
  description = "Command to port-forward Grafana"
  value       = "kubectl port-forward -n infra svc/grafana 3000:3000"
}

output "jenkins_port_forward" {
  description = "Command to port-forward Jenkins"
  value       = "kubectl port-forward -n infra svc/jenkins 8081:8081"
}