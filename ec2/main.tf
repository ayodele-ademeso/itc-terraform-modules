data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Create Security group
resource "aws_security_group" "example" {
  name   = "sg"
  vpc_id = aws_vpc.example.id

  ingress = {}
  egress  = {}

  tags = {}
}

# Create IAM role
resource "aws_iam_role" "ec2_instance_role" {
  name               = "instance_iam_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ec2:Describe*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

#   inline_policy {
#     name   = "policy-8675309"
#     policy = data.aws_iam_policy_document.inline_policy.json
#   }

}

# data "aws_iam_policy_document" "inline_policy" {
#   statement {
#     actions   = ["ec2:DescribeAccountAttributes"]
#     resources = ["*"]
#   }
# }

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create Key pair

# Create EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  availability_zone = var.availability_zone
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name
  launch_template = {}
  root_block_device {
    volume_size = var.root_block_device_size
    tags = {}
  }
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id
  user_data = <<-EOF #var.user_data
  #!/bin/bash

  set -e
  echo "This is a userdatascript"
  sudo yum update -y
  sudo yum install nginx git -y
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
  

  tags = merge(var.ec2_instance_tags, var.common_tags)
}