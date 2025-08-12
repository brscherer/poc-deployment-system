variable "prefix" {
  type        = string
  default     = ""
  description = "Used on tests to change the name of the resources"
}

variable "ghcr_username" {
  type        = string
  description = "GitHub Container Registry username"
  default     = "brscherer"
}

variable "ghcr_token" {
  type        = string
  description = "GitHub Container Registry token"
  sensitive   = true
}

variable "jenkins_admin_password" {
  type        = string
  description = "Jenkins admin password"
  sensitive   = true
  default     = "admin"
}