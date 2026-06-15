# ── S3 Bucket ─────────────────────────────────────────────────────
{%- if values.aws_resource_type == "s3_bucket" %}
resource "aws_s3_bucket" "main" {
  bucket = "${{ values.resource_name }}-${{ values.environment }}"
}

resource "aws_s3_bucket_versioning" "main" {
  count  = var.s3_versioning ? 1 : 0
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.s3_encryption ? 1 : 0
  bucket = aws_s3_bucket.main.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
{%- endif %}

# ── EC2 Instance ───────────────────────────────────────────────────
{%- if values.aws_resource_type == "ec2_instance" %}
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type

  tags = {
    Name = "${{ values.resource_name }}-${{ values.environment }}"
  }
}
{%- endif %}

# ── RDS Instance ───────────────────────────────────────────────────
{%- if values.aws_resource_type == "rds_instance" %}
resource "aws_db_instance" "main" {
  identifier        = "${{ values.resource_name }}-${{ values.environment }}"
  engine            = var.rds_engine
  engine_version    = var.rds_engine == "mysql" ? "8.0" : "15"
  instance_class    = var.rds_instance_class
  allocated_storage = 20
  db_name           = replace("${{ values.resource_name }}", "-", "_")
  username          = "admin"
  password          = random_password.db.result
  skip_final_snapshot = true

  tags = {
    Name = "${{ values.resource_name }}-${{ values.environment }}"
  }
}

resource "random_password" "db" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${{ values.environment }}/${{ values.resource_name }}/db_password"
  type  = "SecureString"
  value = random_password.db.result
}
{%- endif %}

# ── SQS Queue ──────────────────────────────────────────────────────
{%- if values.aws_resource_type == "sqs_queue" %}
resource "aws_sqs_queue" "main" {
  name                      = "${{ values.resource_name }}-${{ values.environment }}"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Name = "${{ values.resource_name }}-${{ values.environment }}"
  }
}
{%- endif %}

# ── SNS Topic ──────────────────────────────────────────────────────
{%- if values.aws_resource_type == "sns_topic" %}
resource "aws_sns_topic" "main" {
  name = "${{ values.resource_name }}-${{ values.environment }}"

  tags = {
    Name = "${{ values.resource_name }}-${{ values.environment }}"
  }
}
{%- endif %}