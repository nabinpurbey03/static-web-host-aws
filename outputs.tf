output "s3_website_url" {
  description = "The URL of the S3 hosted static website from the S3 module"
  value       = module.s3.website_url
}
