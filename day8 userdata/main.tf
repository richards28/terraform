resource "aws_instance" "dev" {
    ami = " "
    instance_type = " "
    key_name = " "
    user_data = file("script.sh")
    tags = {
      Name = "ec2"
    }
}

    
