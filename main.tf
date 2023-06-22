provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATFXGWHCNBDVCBS7H"
  secret_key = "5V5v90/9DEr+I1AGryER7wQFtmRBs2Qe7ryMR1YJ"
}

resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
}
