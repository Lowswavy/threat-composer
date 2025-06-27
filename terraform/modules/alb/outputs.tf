output "dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "zone_id" {
  value = aws_lb.this.zone_id
}