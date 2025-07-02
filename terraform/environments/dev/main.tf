data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
  name         = "ahmedlabs.com."
  private_zone = false
}

module "vpc" {
  source              = "../../modules/vpc"
  name                = "vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
}

module "alb" {
  source = "../../modules/alb"

  name              = "dev"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  certificate_arn   = module.acm.certificate_arn
}

module "ecs" {
  source             = "../../modules/ecs"
  cluster_name       = "ecs"
  name_prefix        = "myapp"
  container_name     = "latest"
  container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-2.amazonaws.com/ecs-assignment:latest"
  container_port     = 80
  target_group_arn   = module.alb.target_group_arn
  subnet_ids         = module.vpc.public_subnets
  vpc_id             = module.vpc.vpc_id
  alb_security_group = module.alb.alb_sg_id

  depends_on = [
    module.alb
  ]
}

module "route53" {
  source = "../../modules/route53"

  zone_id       = data.aws_route53_zone.selected.zone_id
  domain_name  = "tm.ahmedlabs.com"
  alb_dns_name = module.alb.dns_name
  alb_zone_id  = module.alb.zone_id
}

module "acm" {
  source            = "../../modules/acm"
  acm_domain_name   = var.acm_domain_name
  route53_zone_id   = data.aws_route53_zone.selected.zone_id
  dns_ttl           = var.dns_ttl
  validation_method = var.validation_method
}