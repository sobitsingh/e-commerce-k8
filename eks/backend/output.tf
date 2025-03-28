output "bastian_host_public_ip" {
  value = aws_instance.bastian-host.public_ip
  description = "Public IP of the Bastion Host"
}