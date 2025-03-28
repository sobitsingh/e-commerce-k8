provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-${var.aws_region}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.environment-name[0]
  }
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST" # No need to specify read/write capacity
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = var.environment-name[0]
  }
}

resource "aws_vpc" "bastian-vpc" {
  cidr_block           = "172.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "Bastion VPC"
    Environment = var.environment-name[0]
  }
}

resource "aws_security_group" "bastian-sg" {
  name = "bastian-sg"
  vpc_id = aws_vpc.bastian-vpc.id
  tags = {
    Name        = "Bastion Security Group"
    Environment = var.environment-name[0]
  }
  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port = egress.value
      to_port   = egress.value
      protocol  = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
#Attach internet gateway to the VPC
resource "aws_internet_gateway" "bastian-igw" {
  vpc_id = aws_vpc.bastian-vpc.id
  tags = {
    Name        = "Bastion Internet Gateway"
    Environment = var.environment-name[0]
  }
}
#Create a route table for the VPC 
resource "aws_route_table" "bastian-rt" {
  vpc_id = aws_vpc.bastian-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastian-igw.id
  }
  tags = {
    Name        = "Bastion Route Table"
    Environment = var.environment-name[0]
  }
}

#Associate the route table with the subnet
resource "aws_route_table_association" "bastian-rt-assoc" {
  subnet_id      = aws_subnet.bastian-subnet.id
  route_table_id = aws_route_table.bastian-rt.id
}
resource "aws_subnet" "bastian-subnet" {
  vpc_id = aws_vpc.bastian-vpc.id
  availability_zone = "us-east-1a" # Change this to your desired AZ
  cidr_block = "172.0.0.0/25"
}

resource "aws_instance" "bastian-host" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.bastian-sg.id]
  subnet_id     = aws_subnet.bastian-subnet.id
  depends_on    = [aws_route_table_association.bastian-rt-assoc]
  
  associate_public_ip_address = true
  key_name = var.key-name

  #run user_data.sh from filepath
  user_data = file("user_data.sh")
  tags = {
    Name        = "Bastion Host"
    Environment = var.environment-name[0]
  }
}
