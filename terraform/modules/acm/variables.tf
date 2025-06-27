variable "acm_domain_name" {
  default     = "tm.ahmedlabs.com"  
}

variable "route53_zone_id" {
  default = "Z08188972HB2QHSQ536IA"
}

variable "validation_method" {
   default = "DNS"
}

variable "dns_ttl" {
  default = 300
}