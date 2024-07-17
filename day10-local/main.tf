locals {
  bucket-name = "stephen.richards"
}

resource "aws_s3_bucket" "name" {
    bucket = local.bucket-name

  
}