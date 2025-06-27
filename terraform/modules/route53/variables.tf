variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}
