variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Change this to your desired region
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-locks" # Replace with your desired table name
}

variable "ami" {
  description = "value of ami"
  type        = string
  default     = "ami-084568db4383264d4" # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "The instance type for the bastion host"
  type        = string
  default     = "t2.medium" # Replace with your desired instance type
}

variable "environment-name" {
  description = "dev-prod-env"
  type        = list(string)
  default     = ["dev", "prod"]
}

variable "key-name" {
  description = "The name of the key pair for SSH access"
  type        = string
  default = "bastian-key"
}

variable "ingress" {
  description = "sg-ingress"
  type = list(number)
  default = [22, 80, 443]
}

variable "egress" {
  description = "sg-egress"
  type = list(number)
  default = [22, 80, 443]
}