#creates the alb 
resource "aws_lb" "this" {
  name               = "${var.name}-alb" #uses value of the name
  internal           = false #public facing, accessible over the internet
  load_balancer_type = "application" #specifies type
  security_groups    = [aws_security_group.alb.id] #controls traffic in/out
  subnets            = var.public_subnet_ids #attached to my subnets

  
  tags = {
    Environment = "${var.name}-alb"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id      = var.vpc_id
  #allows inbound traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#allows to send outbound traffic anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


   tags = {
    Name = "${var.name}-alb-sg"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

#creates target group
resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg-${random_id.suffix.hex}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

   health_check {
    enabled             = true
    path                = "/"
    port                = "80"    
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#listens on port 443
resource "aws_lb_listener" "https" {
  depends_on = [aws_lb_target_group.this]

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" #defines encyption
  certificate_arn   = var.certificate_arn
#once someone hits via alb, forwads to target group (ecs)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  lifecycle {
    prevent_destroy = false
  }

}

# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.test.arn
#   target_id        = aws_instance.test.id
#   port             = 80
# #}
