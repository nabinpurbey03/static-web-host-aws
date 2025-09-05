terraform {
  backend "local" {
    path = "./state-files/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "cloudfront" {
  source           = "./modules/cloudfront"
  s3_bucket_domain = module.s3.bucket_domain_name
  s3_bucket_arn    = module.s3.bucket_arn
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "${var.bucket_name}-${random_id.suffix.hex}"
}



