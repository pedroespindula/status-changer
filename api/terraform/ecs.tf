locals {
  repository_name = "status_changer"
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_ecr_repository" "status_changer" {
  name                 = local.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "status_changer" {
  repository = aws_ecr_repository.status_changer.name
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "adds full ecr access to the status_changer repository",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
    }
  )
}

resource "aws_ecs_cluster" "status_changer" {
  name = "status_changer"
}

resource "aws_ecs_task_definition" "status_changer" {
  family                   = "status_changer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = aws_iam_role.status_changer.arn
  container_definitions = jsonencode([
    {
      "name" : "status_changer",
      "image" : aws_ecr_repository.status_changer.repository_url,
      "memory" : 1024,
      "cpu" : 512,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ]
    }
  ])
}

resource "aws_iam_role" "status_changer" {
  name               = "status_changer"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "status_changer" {
  role       = aws_iam_role.status_changer.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "status_changer" {
  name            = "status_changer"
  cluster         = aws_ecs_cluster.status_changer.id
  task_definition = aws_ecs_task_definition.status_changer.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnet_ids.default.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.status_changer.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.status_changer.arn
    container_name   = aws_ecs_task_definition.status_changer.family
    container_port   = 80
  }

  desired_count = 1
}

resource "aws_alb" "status_changer" {
  name               = "status-changer"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.status_changer.id]
}

resource "aws_security_group" "status_changer" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "status_changer" {
  name        = "status-changer"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
  health_check {
    matcher = "200"
    path    = "/"
  }
}

resource "aws_lb_listener" "status_changer" {
  load_balancer_arn = aws_alb.status_changer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.status_changer.arn
  }
}
