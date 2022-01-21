resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.aws_tags, {
    Name = var.name
  })
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "adds full ecr access to the ${var.name} repository",
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

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"

  tags = merge(var.aws_tags, {
    Name = "${var.name}-cluster"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.memory
  cpu                      = var.cpu
  execution_role_arn       = aws_iam_role.this.arn
  container_definitions = jsonencode([
    {
      "name" : var.name,
      "image" : aws_ecr_repository.this.repository_url,
      "memory" : var.memory,
      "cpu" : var.cpu,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : var.container_port,
          "hostPort" : 80
        }
      ]
    }
  ])

  tags = merge(var.aws_tags, {
    Name = "${var.name}-task-definition"
  })
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(var.aws_tags, {
    Name = "${var.name}-iam-role"
  })
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

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = [aws_security_group.this.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  desired_count = 1

  tags = merge(var.aws_tags, {
    Name = "${var.name}-service"
  })
}

resource "aws_alb" "this" {
  name               = "${var.name}-load-balancer"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.this.id]

  tags = merge(var.aws_tags, {
    Name = "${var.name}-load-balancer"
  })
}

resource "aws_security_group" "this" {
  name        = "${var.name}-security-group"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id


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

  tags = merge(var.aws_tags, {
    Name = "${var.name}-security-group"
  })
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    matcher = "200"
    path    = "/"
  }

  tags = merge(var.aws_tags, {
    Name = "${var.name}-target-group"
  })
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
