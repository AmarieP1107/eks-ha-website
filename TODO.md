# TODO — What I Would Do With More Time
## Infrastructure Improvements

Terraform Remote State — Configure an S3 backend with DynamoDB locking for Terraform state management. This allows multiple team members to safely run Terraform without conflicts
AWS Load Balancer Controller — Replace the manual target group registration with the AWS Load Balancer Controller running inside EKS. This would automate target registration and allow Kubernetes Ingress resources to manage the ALB directly
Multi-AZ NAT Gateway — Add a second NAT Gateway in eu-west-2b. Currently a single NAT Gateway is a potential single point of failure
Terraform Workspaces — Implement separate workspaces for dev, staging, and production environments
VPC Flow Logs — Enable VPC flow logs to capture network traffic metadata for security analysis

## Security Improvements

AWS Secrets Manager — Replace Kubernetes Secrets with AWS Secrets Manager for database credential management with automatic rotation
EKS Private Endpoint — Disable the public EKS endpoint and restrict kubectl access to inside the VPC only
WAF — Add AWS WAF to the ALB to protect against common web attacks like SQL injection and XSS
RDS Encryption — Enable encryption at rest for the RDS instance
Pod Security Policies — Implement Kubernetes pod security policies to restrict what containers can do
Network Policies — Add Kubernetes network policies to restrict pod-to-pod communication
Container Scanning — Add ECR image scanning on push to detect vulnerabilities in Docker images
IRSA — Implement IAM Roles for Service Accounts instead of node-level IAM roles for more granular pod-level permissions

## Application Improvements

Database Migrations — Implement a proper database migration tool like Alembic to manage schema changes
Connection Pooling — Add database connection pooling to handle high traffic efficiently
Caching Layer — Add ElastiCache Redis as a caching layer between the app and database
Horizontal Pod Autoscaling — Configure HPA to automatically scale pods based on CPU and memory usage

## Observability Improvements

CloudWatch Synthetics — Set up synthetic canary tests to continuously validate the website is up from multiple locations
AWS X-Ray — Implement distributed tracing to follow requests through the entire system
CloudWatch Dashboard — Build a CloudWatch dashboard showing key metrics in one view
Log Aggregation — Configure Fluent Bit as a DaemonSet on EKS to automatically ship container logs to CloudWatch
PagerDuty Integration — Connect CloudWatch alarms to PagerDuty for on-call alerting

## CI/CD Improvements

Environment Promotion — Implement a staging environment with promotion gates before deploying to production
Automated Testing — Add unit tests and integration tests to the CI pipeline
Security Scanning — Add SAST/DAST scanning to the pipeline using tools like Snyk or Trivy
Rollback Mechanism — Implement automated rollback if the deployment health check fails