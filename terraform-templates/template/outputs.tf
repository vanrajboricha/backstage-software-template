${% if values.aws_resource_type == "s3_bucket" %}
output "bucket_name" {
  value       = aws_s3_bucket.main.bucket
  description = "S3 bucket name"
}
output "bucket_arn" {
  value       = aws_s3_bucket.main.arn
  description = "S3 bucket ARN"
}
${% endif %}

${% if values.aws_resource_type == "ec2_instance" %}
output "instance_id" {
  value       = aws_instance.main.id
  description = "EC2 instance ID"
}
output "public_ip" {
  value       = aws_instance.main.public_ip
  description = "EC2 public IP"
}
${% endif %}

${% if values.aws_resource_type == "rds_instance" %}
output "db_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "RDS endpoint"
}
output "db_password_ssm_path" {
  value       = aws_ssm_parameter.db_password.name
  description = "SSM path for DB password"
}
${% endif %}

${% if values.aws_resource_type == "sqs_queue" %}
output "queue_url" {
  value       = aws_sqs_queue.main.url
  description = "SQS queue URL"
}
output "queue_arn" {
  value       = aws_sqs_queue.main.arn
  description = "SQS queue ARN"
}
${% endif %}

${% if values.aws_resource_type == "sns_topic" %}
output "topic_arn" {
  value       = aws_sns_topic.main.arn
  description = "SNS topic ARN"
}
${% endif %}