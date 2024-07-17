terraform {
  backend "s3" {
    bucket = "wolverinex.online"
    key = "terro"
    region = "ap-northeast-1"
    dynamodb_table = "terro"
    encrypt = true
    
  }
}