resource "aws_s3_bucket" "contents" {
  bucket = var.contents_bucket_name
  acl    = "private"
  policy = data.template_file.s3_policy.rendered

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "contents" {
  bucket                  = aws_s3_bucket.contents.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs" {
  bucket = var.logs_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "template_file" "s3_policy" {
  template = file("${path.module}/s3_policy.json.tpl")

  vars = {
    bucket_name            = var.contents_bucket_name
    origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.id
  }
}

