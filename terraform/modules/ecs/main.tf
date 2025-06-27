
resource "aws_ecs_cluster" "test" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecstaskexecutionrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
})
}

resource "aws_iam_role_policy" "ecs_task_execution_logging" {
  name = "ecsTaskExecutionLogsPolicy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
 

resource "aws_ecs_service" "test" {
  name            = "${var.name_prefix}"
  cluster         = aws_ecs_cluster.test.id
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]

  network_configuration {
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.ecs_tasks.id]
  assign_public_ip = true
}

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

# resource "aws_ecs_task_definition" "test" {
#   family                   = "${var.name_prefix}"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = 1024
#   memory                   = 2048
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   container_definitions    = jsonencode([{

#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-group": "ecs_log_group2",
#         "awslogs-region": "eu-west-2",
#         "awslogs-stream-prefix": "logs_prefix"
#       }
#     }
  
#     "name" = var.container_name,
#     "image" = var.container_image,
#     "cpu" = 1024,
#     "memory" = 2048,
#     "essential" = true,
#     portMappings = [
#         {
#           containerPort = var.container_port,
#           hostPort      = var.container_port,
#           protocol      = "tcp"
#         }
#       ]
# }])
# }

resource "aws_ecs_task_definition" "test" {
  family = "${var.name_prefix}"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    
    {
          "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "ecs-log-group2",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "logs_prefix"
      }
    }
      name      = var.container_name,
      image     = var.container_image,
      cpu                      = 1024
      memory                   = 2048
      essential = true
      portMappings = [
        {
          containerPort = var.container_port,
          hostPort      = var.container_port,
        }
      ]
    },

  ])
runtime_platform {
  operating_system_family = var.operating_system_family
  cpu_architecture        = var.cpu_architecture
}
}



resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name_prefix}-ecs-tasks-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_security_group]
    description     = "Allow all traffic from ALB security group"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "ecs-log-group2"
}