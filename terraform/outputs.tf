output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "db_endpoint" {
  description = "Endpoint for the RDS instance"
  value       = module.rds.db_endpoint
}