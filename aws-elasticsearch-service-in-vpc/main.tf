resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.prefix
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type  = var.elasticsearch_instance_type
    instance_count = var.elasticsearch_instance_count

    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = var.elasticsearch_availability_zone_count
    }
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.es.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }

  snapshot_options {
    automated_snapshot_start_hour = 13
  }
}

resource "aws_elasticsearch_domain_policy" "es" {
  domain_name = aws_elasticsearch_domain.es.domain_name

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.es.arn}/*"
        }
    ]
}
CONFIG

}

resource "aws_security_group" "es" {
  name        = "${var.prefix}-elasticsearch"
  description = "${var.prefix}-elasticsearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.ingress_cidr_blocks
  }
}

