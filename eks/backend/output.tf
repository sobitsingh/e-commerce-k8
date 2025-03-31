output "bastian_host_public_ip" {
  value = aws_instance.bastian-host.public_ip
  description = "Public IP of the Bastion Host"
}

output "aws_s3_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
  description = "S3 bucket for Terraform state"
}