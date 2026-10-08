resource "aws_s3_bucket" "observability" {
  bucket = "${var.cluster_name}-${var.environment}-observability"

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-observability"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "observability"
  }
}

resource "aws_s3_bucket_public_access_block" "observability" {
  bucket = aws_s3_bucket.observability.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "observability" {
  bucket = aws_s3_bucket.observability.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "observability" {
  bucket = aws_s3_bucket.observability.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Logical prefixes for each backend
resource "aws_s3_object" "metrics_prefix" {
  bucket  = aws_s3_bucket.observability.id
  key     = "metrics/"
  content = ""
}

resource "aws_s3_object" "logs_prefix" {
  bucket  = aws_s3_bucket.observability.id
  key     = "logs/"
  content = ""
}

resource "aws_s3_object" "traces_prefix" {
  bucket  = aws_s3_bucket.observability.id
  key     = "traces/"
  content = ""
}