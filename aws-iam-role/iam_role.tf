data "aws_iam_policy_document" "policy1" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::foo-bucket/*",
    ]
  }
}

resource "aws_iam_policy" "policy1" {
  name        = "${var.prefix}-policy1"
  path        = "/"
  description = ""
  policy      = data.aws_iam_policy_document.policy1.json
}

data "aws_iam_policy_document" "role1_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role1" {
  name               = "${var.prefix}-role1"
  assume_role_policy = data.aws_iam_policy_document.role1_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "role1_attachement" {
  role       = aws_iam_role.role1.name
  policy_arn = aws_iam_policy.policy1.arn
}

