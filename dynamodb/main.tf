resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamodb_table_name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key

  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  tags = merge(var.dynamodb_tags, var.common_tags)

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}