# IAM is created to allow access to EC2 instances/Applications using SSM. 
# SSM is used for patch-management, troubleshooting and overall management of EC2 instances
# SSM require specific ami, for this reason community/connoical AMI "099720109477" was used 

# For SSM we will need an IAM Role, Assume Role policy, a profile and SSM Permission policy_arn

resource "aws_iam_role" "ssm" {
  name = "SSM_ACCESS"
  path = "/"

  assume_role_policy = <<EOF
  {
        "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Now Create The Profile for SSM
resource "aws_iam_instance_profile" "ssmprofile" {
  name = "${aws_iam_role.ssm.name}-profile"
  role = aws_iam_role.ssm.ssm.name
}

# Now Set SSM Permissions, SSM requires the following policy arn AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "ssm_permissions" {
  policy_arn = "arn:aws:iam:aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.ssm.name
}


