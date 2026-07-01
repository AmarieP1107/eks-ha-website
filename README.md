# EKS Highly Available Website
A highly available web application deployed on AWS EKS using Terraform for infrastructure as code, with CI/CD pipelines built on GitHub Actions.
## Architecture Overview
The architecture follows a classic three-tier design across two AWS availability zones (eu-west-2a and eu-west-2b) for high availability:

Public Layer: Application Load Balancer with SSL termination
Application Layer: Python Flask app running on EKS worker nodes
Data Layer: MySQL database on RDS with Multi-AZ failover

Traffic flow: Internet → ALB (HTTPS/443) → EKS Worker Nodes (NodePort) → Kubernetes Service → Flask Pods → RDS MySQL
## Infrastructure Components
### VPC

CIDR: 10.0.0.0/16
2 public subnets across eu-west-2a and eu-west-2b
2 private subnets across eu-west-2a and eu-west-2b
Internet Gateway for public subnet internet access
NAT Gateway for private subnet outbound access
Separate route tables for public and private subnets

### EKS

Kubernetes version 1.32
Managed node group with t3.small instances
2 worker nodes across 2 availability zones (min: 2, max: 4)
Separate IAM roles for cluster and worker nodes following least privilege

### RDS

MySQL 8.0 on db.t3.micro
Multi-AZ deployment for automatic failover
Private subnet placement — not publicly accessible
Security group restricting access to port 3306 from EKS only

### ALB

Application Load Balancer in public subnets
HTTP to HTTPS redirect (301)
SSL certificate via AWS Certificate Manager
TLS 1.3 security policy

### Monitoring

CloudWatch log group for application logs (7 day retention)
CloudWatch alarms for EKS CPU, RDS CPU, and RDS storage
SNS topic for alarm notifications via email

## CI/CD Pipelines
### CI Pipeline
Triggers on any push to app/. Steps:

Builds Docker image for linux/amd64
Pushes image to ECR tagged with Git commit SHA
Updates k8s/deployment.yaml with new image tag
Commits the update back to the repository

### CD Pipeline
Triggers when CI pipeline completes or on changes to k8s/. Steps:

Configures kubectl to connect to EKS
Applies updated Kubernetes manifests
Waits for rollout to complete successfully

### GitOps Workflow
The deployment history is fully visible in Git commit history. Every deployment is triggered by a commit — the image tag in k8s/deployment.yaml is the source of truth for what version is running in production.
## Security Considerations
### Network Security

EKS worker nodes and RDS live in private subnets — not directly accessible from the internet
RDS security group only allows MySQL traffic (port 3306) from the EKS security group
ALB security group only allows HTTP (80) and HTTPS (443) from the internet
HTTP traffic is automatically redirected to HTTPS

### IAM and Credentials

Separate IAM roles for EKS cluster and worker nodes following least privilege principle
Terraform uses an IAM user with scoped permissions — in production this would be further restricted
Database credentials stored in Kubernetes Secrets, never hardcoded in application code
terraform.tfvars containing sensitive values is gitignored and never committed to source control
In production, credentials would be managed via AWS Secrets Manager

### Container Security

Docker images built for specific target platform (linux/amd64)
Base image uses python:3.11-slim to minimise attack surface
Application runs via gunicorn in production mode

### Pipeline Security

AWS credentials stored as GitHub Secrets — never exposed in logs or code
Pipeline has read/write permissions scoped to the repository only

### Production Improvements

Enable EKS private endpoint only (disable public endpoint)
Add WAF to the ALB for protection against common web attacks
Enable RDS encryption at rest
Implement pod security policies
Use AWS Secrets Manager instead of Kubernetes Secrets for credential management

## Validating the Website is Up
### Current Implementation

ALB health checks ping the / endpoint every 30 seconds on each target
Kubernetes liveness probes restart pods that stop responding
Kubernetes readiness probes prevent traffic reaching pods that aren't ready
CloudWatch alarms alert on high CPU and low storage

### Production Approach

Set up a CloudWatch Synthetics canary — a scheduled synthetic test that hits https://amarie-dev.xyz every minute and alerts if it fails
Use Route53 health checks to monitor the endpoint and trigger DNS failover if needed
Implement an uptime monitoring service like Datadog or PagerDuty for on-call alerting

## Strengths and Weaknesses
### Strengths

Fully modular Terraform architecture — each component is independently maintainable
High availability across two availability zones for both compute and database layers
Full GitOps workflow — Git is the single source of truth for deployed versions
Automated CI/CD — no manual deployment steps required
SSL/TLS enforced — all traffic encrypted in transit
Infrastructure is fully reproducible — destroy and rebuild with a single command

### Weaknesses

Target group registration done manually via CLI rather than AWS Load Balancer Controller
Single NAT Gateway is a potential availability risk — in production you'd have one per availability zone
NodePort approach for ALB routing is not ideal for production — AWS Load Balancer Controller with Ingress would be cleaner
RDS backup retention disabled due to free tier limitations — in production this would be 7+ days
EKS public endpoint enabled for convenience — in production this would be disabled
No Terraform remote state backend configured — in production state would be stored in S3 with DynamoDB locking