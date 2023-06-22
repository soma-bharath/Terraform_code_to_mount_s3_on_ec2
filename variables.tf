#218453391514
variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "subnet_names" {
  type    = list(string)
  default = ["subnet-1", "subnet-2", "subnet-3"]
}

variable "instance_names" {
  type    = list(string)
  default = ["one", "two", "three"]
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default="mybucket39443"
  # Add any additional configuration options as needed
}
