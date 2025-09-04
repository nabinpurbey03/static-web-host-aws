output "website_url" {
  description = "The URL of the S3 hosted static website"
  value       = aws_s3_bucket_website_configuration.web_conf.website_endpoint
}

output "website_url2" {
  description = "Static website URL hosted on S3"
  value       = "http://${aws_s3_bucket.tf_bucket.website_endpoint}"
}
