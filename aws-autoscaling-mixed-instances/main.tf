resource "aws_launch_template" "template" {
  name_prefix   = "${var.prefix}-instances-"
  image_id      = var.ami_id
  instance_type = var.instance_types[0]

  vpc_security_group_ids = [aws_security_group.instances.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.instances.arn
  }
}

resource "aws_autoscaling_group" "autoscaling" {
  max_size            = var.autoscale_max_size
  min_size            = var.autoscale_min_size
  name                = var.prefix
  vpc_zone_identifier = var.subnet_ids

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.template.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types

        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = var.autoscale_on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.autoscale_on_demand_percentage_above_base_capacity
      spot_instance_pools                      = 2
    }
  }

  depends_on = [aws_launch_template.template]
}

resource "aws_security_group" "instances" {
  name   = "${var.prefix}-instances"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "instances" {
  name = "${var.prefix}-instances"
  role = aws_iam_role.instances_role.name
}

data "aws_iam_policy_document" "instances_role_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instances_role" {
  name               = "${var.prefix}-instances-role"
  assume_role_policy = data.aws_iam_policy_document.instances_role_assume_policy.json
}

