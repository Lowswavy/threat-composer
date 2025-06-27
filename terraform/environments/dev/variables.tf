variable "acm_domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID to create validation records"
  type        = string
}

variable "dns_ttl" {
  type        = number
  description = "TTL for DNS records"
}

variable "validation_method" {
  type        = string
  description = "The validation method used for the ACM certificate"
}
