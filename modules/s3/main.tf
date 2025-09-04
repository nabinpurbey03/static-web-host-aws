resource "aws_s3_bucket" "tf_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_ctrl" {
  bucket = aws_s3_bucket.tf_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my_acl" {
  bucket = aws_s3_bucket.tf_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_ctrl,
    aws_s3_bucket_public_access_block.public_access_block
  ]
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "web_conf" {
  bucket = aws_s3_bucket.tf_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.tf_bucket.id
  key    = "index.html"
  source = "${path.root}/public/index.html"
  # acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.tf_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.tf_bucket.arn}/*"
      }
    ]
  })
}



# Policy that allows ONLY CloudFront OAI to read
# resource "aws_s3_bucket_policy" "this" {
#   bucket = aws_s3_bucket.this.id
#   policy = data.aws_iam_policy_document.s3_policy.json
# }

# data "aws_iam_policy_document" "s3_policy" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = [var.oai_iam_arn]
#     }

#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.this.arn}/*"]
#   }
# }
