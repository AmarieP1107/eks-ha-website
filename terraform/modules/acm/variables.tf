variable "domain_name" {
  description = "Domain name for the SSL certificate"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name e.g dev, prod"
  type        = string
  default     = "dev"
}