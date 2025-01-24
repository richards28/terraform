resource "aws_instance" "dev" {
    ami = "ami-0fb04413c9de69305"
    instance_type = "t2.micro"
    key_name = "3tier"
    user_data = file("script.sh")
    tags = {
      Name = "ec2"
    }
}

    
