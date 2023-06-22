
resource "aws_iam_instance_profile" "demo-profile" {
  name = "demo_profile"
  role = aws_iam_role.s3_access_role.name
}

resource "aws_instance" "instances" {
  count         = length(var.instance_names)
  ami           = "ami-057752b3f1d6c4d6c"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  iam_instance_profile = aws_iam_instance_profile.demo-profile.name
  tags = {
    Name = "instance-${var.instance_names[count.index]}"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y s3fs-fuse
    sudo yum install docker -y
    echo "s3_bucket_name = ${var.s3_bucket_name}" > /tmp/user-data
    S3_BUCKET_NAME=$(curl -s http://169.254.169.254/latest/user-data | grep -oP '(?<=s3_bucket_name = ).*')
    MOUNT_POINT="/mnt/s3"

# Fetch the IAM role name from Terraform output
IAM_ROLE_NAME=IAM_ROLE_NAME=$(aws iam list-roles --query "Roles[?contains(Arn,'$(curl -s http://169.254.169.254/latest/meta-data/instance-id)')].RoleName" --output text)

# Create the mount point directory
sudo mkdir -p $MOUNT_POINT

# Mount the S3 bucket using IAM role credentials
sudo s3fs $S3_BUCKET_NAME $MOUNT_POINT -o iam_role="$IAM_ROLE_NAME" -o allow_other

# Add the S3 bucket to /etc/fstab for automatic mounting on instance reboot
echo "$S3_BUCKET_NAME $MOUNT_POINT fuse.s3fs _netdev,iam_role=$IAM_ROLE_NAME,allow_other 0 0" | sudo tee -a /etc/fstab

# Ensure proper permissions on the mount point
sudo chown ec2-user:ec2-user $MOUNT_POINT

# Additional commands or configurations can be added below

# Example: Create a test file in the mounted S3 bucket
sudo touch $MOUNT_POINT/test.txt
sudo echo "This is a test file" | sudo tee -a $MOUNT_POINT/test.txt

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
