
resource "aws_iam_instance_profile" "demo-profile" {
  name = "demo_profile"
  role = aws_iam_role.s3_access_role.name
}

resource "aws_instance" "instances" {
  count         = length(var.instance_names)
  ami           = "ami-0395649fbe870727e"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  iam_instance_profile = aws_iam_instance_profile.demo-profile.name
  tags = {
    Name = "instance-${var.instance_names[count.index]}"
  }

  user_data = <<-EOF
    #!/bin/bash
    mkdir /home/ec2-user/localpath
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    bucket_name=$(aws s3 ls | awk -F" " '{print($3)}')
    sudo wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm
    sudo yum install -y ./mount-s3.rpm
    mount-s3 $bucket_name /home/ec2-user/localpath
# End of user data script
  EOF
  depends_on = [
  aws_vpc.prod-vpc,
  aws_subnet.subnets,
  aws_s3_bucket.example,
  aws_iam_role.s3_access_role,
  aws_iam_instance_profile.demo-profile
]
}
