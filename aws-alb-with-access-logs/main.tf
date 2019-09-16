resource "aws_security_group" "alb_sg" {
  name        = var.prefix
  description = var.prefix
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "alb" {
  idle_timeout    = 60
  internal        = false
  name            = var.prefix
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket = aws_s3_bucket.alb_log.bucket
  }
}

resource "aws_alb_listener" "alb_listener_443" {
  load_balancer_arn = aws_alb.alb.arn

  port            = "443"
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2015-05"
  certificate_arn = var.acm_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb" {
  name        = var.prefix
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path    = "/ping"
    matcher = "200-299"
  }
}

data "aws_elb_service_account" "alb_log" {
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.prefix}-alb-log/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_elb_service_account.alb_log.id}:root",
      ]
    }
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.prefix}-alb-log"
  acl    = "private"
  policy = data.aws_iam_policy_document.alb_log.json

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket                  = aws_s3_bucket.alb_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

