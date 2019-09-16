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

resource "aws_iam_role_policy_attachment" "instances_role_attachement" {
  role       = aws_iam_role.instances_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

