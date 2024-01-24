output "dynamodb_arn" {
  description = "ARN of the created Dynamodb table"
  value       = aws_dynamodb_table.dynamodb-table.arn
}

output "dynamodb_id" {
  description = "Name of the created Dynamodb table"
  value       = aws_dynamodb_table.dynamodb-table.id
}