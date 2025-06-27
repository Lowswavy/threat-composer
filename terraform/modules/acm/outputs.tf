output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.cert.arn
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = aws_acm_certificate.cert.status
}

output "certificate_validation_record_fqdns" {
  description = "Fully qualified domain names of the Route53 validation records"
  value       = [for record in aws_route53_record.cert_validation : record.fqdn]
}

output "certificate_domain_name" {
  description = "Domain name of the ACM certificate"
  value       = aws_acm_certificate.cert.domain_name
}
