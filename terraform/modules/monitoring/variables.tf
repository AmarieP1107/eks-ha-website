variable "project_name" {
  description = "Name of the project, used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name e.g dev, prod"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "db_identifier" {
  description = "Identifier of the RDS instance"
  type        = string
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}