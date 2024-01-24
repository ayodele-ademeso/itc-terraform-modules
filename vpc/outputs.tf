output "vpc-id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public01_subnet_id" {
  description = "The ID of public subnet in Availability Zone"
  value       = aws_subnet.public01.id
}

output "public02_subnet_id" {
  description = "The ID of public subnet in Availability Zone"
  value       = aws_subnet.public02.id
}

output "private01_subnet_id" {
  description = "The ID of public subnet in Availability Zone"
  value       = aws_subnet.private01.id
}

output "private02_subnet_id" {
  description = "The ID of public subnet in Availability Zone"
  value       = aws_subnet.private02.id
}