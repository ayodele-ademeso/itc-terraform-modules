module "dynamodb" {
  source              = "../../"
  dynamodb_table_name = "ayodele-movie-table"
  billing_mode        = "PAY_PER_REQUEST"
#   read_capacity       = 5
#   write_capacity      = 5
  hash_key            = "ID"
  attribute_name      = "ID"
  attribute_type      = "N"
  dynamodb_tags = {
    Name = "ayodele-movie-table"
  }
  common_tags = {
    Environment  = var.environment
    "Managed By" = "Terraform"
    "Owned By"   = "Ayodele-UK"
  }

}