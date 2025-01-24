resource "aws_instance" "dev" {
    ami = "ami-0fb04413c9de69305"
    instance_type = "t2.micro"
    key_name = "keypair1"
    user_data = file("script.sh")
    tags = {
      Name = "ec02"
    }
}

    
