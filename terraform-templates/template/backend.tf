terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state in S3
  backend "s3" {
    bucket = "${{ values.tf_state_bucket }}"
    key    = "${{ values.environment }}/${{ values.resource_name }}/terraform.tfstate"
    region = "${{ values.aws_region }}"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment  = var.environment
      ManagedBy    = "terraform"
      CreatedBy    = "backstage"
      ResourceName = var.resource_name
    }
  }
}