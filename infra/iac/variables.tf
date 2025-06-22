variable "infra_namespace" {
  type        = string
  default     = "infra"
  description = "Namespace for Prometheus and Grafana"
}

variable "app_namespace" {
  type        = string
  default     = "apps"
  description = "Namespace for application deployments"
}
