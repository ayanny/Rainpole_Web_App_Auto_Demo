output "ec2_instance_id" {
  values = aws_instance.server.id
}