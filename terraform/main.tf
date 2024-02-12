# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # Define your VPC's CIDR block
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24" # Define your subnet's CIDR block
  availability_zone = "us-east-1a" # Set your desired availability zone
}

# Create a security group
resource "aws_security_group" "sggroup" {
  name        = "sggroup"
  description = "Allow HTTP inbound traffic"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance
resource "aws_instance" "myec2" {
  ami             = "ami-0e731c8a588258d0d" # Set your desired AMI ID
  instance_type   = "t2.micro" # Set your desired instance type
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = aws_security_group.sggroup

  tags = {
    Name = "MyEC2Instance"
  }

  # Provision Nginx on the EC2 instance
  user_data = <<-EOF
              #!/bin/bash
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF
}
