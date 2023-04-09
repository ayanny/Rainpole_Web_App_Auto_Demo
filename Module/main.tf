resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  vpc_security_group_ids      = var.vpc_security_group_ids
  srvr_count                       = var.srvr_count
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_base64_change

  tags = {
    "Name" = var.srvr_tag
  }
}
