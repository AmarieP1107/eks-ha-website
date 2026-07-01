resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name        = "${var.project_name}-certificate"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "domain_validation_options" {
  value = aws_acm_certificate.main.domain_validation_options
}