#!/bin/bash

echo "Please enter your name:"

read name

echo "Hello, Mr.$name! welcome to the s3 mount installation"

sleep 3

echo "installation started.............."

sudo apt-get update -y > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "apt-get updated successfully"
    sleep 3
else
    echo "No"
    sleep 3
fi

sudo apt install s3fs awscli -y > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "s3fs and aws cli installed successfully"
    sleep 3
else
    echo "No"
    sleep 3
fi

cmd_output=$(sudo which s3fs)

expected_value="/usr/bin/s3fs"

# Check if the command output matches the expected value
if [ "$cmd_output" = "$expected_value" ]; then
    echo "Successfully installed s3fs"
    sleep 3
else
    echo "No"
fi

echo "now creating a path to mount the s3 locally"
sudo mkdir /home/ubuntu/s3_uploads

sudo s3fs mount111 /home/ubuntu/s3_uploads -o iam_role=mys3full -o nonempty


if [ $? -eq 0 ]; then
    echo "Mounting completed"
    sleep 10
else
    echo "No"
fi

#cd /home/ubuntu/s3_uploads
sudo touch /home/ubuntu/bharath/file1.txt /home/ubuntu/bharath/file2.txt


if [ $? -eq 0 ]; then
    echo "files created successfully in s3_uploads go and check s3 bucket"
    sleep 3
else
    echo "No"
fi
