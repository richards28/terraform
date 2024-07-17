resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "Myvpc"
    }
  
}
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "subnet1"
    }
}
data "aws_subnet" "data" {
    filter {
    name = "tag:Name"
      values = ["subnet1"]
    }
  
}
resource "aws_instance" "name" {
    ami = "ami-013a28d7c2ea10269"
    instance_type = "t2.micro"
    key_name = "keypair1"
    subnet_id = data.aws_subnet.data.id
    tags = {
        Name = "ec22"
    }
    lifecycle {
      ignore_changes = [ tags ]
      create_before_destroy = true
    
      prevent_destroy = false
    }
  
}
