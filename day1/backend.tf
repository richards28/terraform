terraform {
  backend "s3" {
    bucket = "wolverinex.online"
    key = "day1/terraform.tfstate"
    region = "ap-northeast-1"
    
  }
}