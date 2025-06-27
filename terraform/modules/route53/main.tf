#data "aws_route53_zone" "selected" {
 # name         = var.domain_name
#}
resource "aws_route53_record" "subdomain" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}