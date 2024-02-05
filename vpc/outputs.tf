output "vpc-id" {
  description = "ID of the created VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "public_subnets" {
  description = "List of ID of public subnets"
  value       = var.create_vpc && length(var.public_subnets) > 0 ? aws_subnet.public[*].id : []
}

output "private_subnets" {
  description = "List of ID of private subnets"
  value       = var.create_vpc && length(var.public_subnets) > 0 ? aws_subnet.private[*].id : []
}

output "name" {
  description = "The name of the VPC."
  value       = var.name
}