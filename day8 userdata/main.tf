resource "aws_instance" "dev" {
    ami = "ami-013a28d7c2ea10269"
    instance_type = "t2.micro"
    key_name = "keypair2"
    user_data = file("script.sh")
    tags = {
      Name = "ec2"
    }
}

    