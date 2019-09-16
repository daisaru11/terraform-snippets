resource "aws_s3_bucket" "log_bucket" {
  bucket = var.prefix
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudwatch_log_group" "log" {
  name              = var.prefix
  retention_in_days = 14
  tags              = {}
}

resource "aws_ssm_document" "document" {
  name            = "${var.prefix}-SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<DOC
{
    "schemaVersion": "1.0",
    "description": "Document to hold regional settings for Session Manager",
    "sessionType": "Standard_Stream",
    "inputs": {
        "s3BucketName": "${aws_s3_bucket.log_bucket.id}",
        "s3EncryptionEnabled": false,
        "cloudWatchLogGroupName": "${aws_cloudwatch_log_group.log.name}",
        "cloudWatchEncryptionEnabled": false
    }
}
DOC

}

