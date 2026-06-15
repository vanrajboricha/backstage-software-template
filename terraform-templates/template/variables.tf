variable "resource_name" {
  description = "Name of the resource"
  type        = string
  default     = "${{ values.resource_name }}"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "${{ values.aws_region }}"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "${{ values.environment }}"
}

# S3 variables
variable "s3_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = ${{ values.s3_versioning }}
}

variable "s3_encryption" {
  description = "Enable S3 encryption"
  type        = bool
  default     = ${{ values.s3_encryption }}
}

# EC2 variables
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "${{ values.ec2_instance_type }}"
}

# RDS variables
variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "${{ values.rds_engine }}"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "${{ values.rds_instance_class }}"
}