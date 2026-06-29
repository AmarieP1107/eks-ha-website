variable "project_name" {
  description = "Name of the project, used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name e.g dev, prod"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.small"
}

variable "desired_nodes" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "max_nodes" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}