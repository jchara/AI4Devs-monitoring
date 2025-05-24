resource "aws_s3_bucket" "code_bucket" {
  bucket = "ai4devs-project-code-bucket-2025"
}

resource "aws_s3_bucket_public_access_block" "code_bucket_pab" {
  bucket = aws_s3_bucket.code_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "code_bucket_encryption" {
  bucket = aws_s3_bucket.code_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Los archivos ZIP se crean manualmente - no necesitamos null_resource en Windows
resource "aws_s3_bucket_object" "backend_zip" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "backend.zip"
  source = "${path.module}/../backend.zip"
}

resource "aws_s3_bucket_object" "frontend_zip" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "frontend.zip"
  source = "${path.module}/../frontend.zip"
}
