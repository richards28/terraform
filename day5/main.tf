resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "myvpc"
    }
}
resource "aws_internet_gateway" "dev" {
    vpc_id = aws_vpc.dev.id
    tags ={
        Name = "my-ig"
    } 
}
resource "aws_subnet" "dev" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.dev.id
    tags = {
      Name="publicsubnet"
    }
  
}
resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "my-RT"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev.id
    }
  
}
resource "aws_route_table_association" "dev" {
    subnet_id = aws_subnet.dev.id
    route_table_id = aws_route_table.dev.id
  
}
resource "aws_security_group" "dev" {
    vpc_id = aws_vpc.dev.id
    name = "mysg22"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 00
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
#creating natgateway
resource "aws_nat_gateway" "dev" {
    connectivity_type = "public"
    allocation_id = aws_eip.dev.id
    subnet_id = aws_subnet.dev.id
    tags = {
      Name = "my-nat"
    }
  
}
resource "aws_eip" "dev" {
    domain = "vpc"
  
}
resource "aws_subnet" "dev2" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "private subnet"
    }
}
resource "aws_route_table" "dev2" {
    vpc_id = aws_vpc.dev.id
    tags = {
        Name ="my-RT2" 
    }
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.dev.id
    }
  
}
resource "aws_route_table_association" "dev2" {
    subnet_id = aws_subnet.dev2.id
    route_table_id = aws_route_table.dev2.id
  
}
resource "aws_instance" "dev" {
    ami = "ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    subnet_id = aws_subnet.dev.id
    security_groups = [aws_security_group.dev.id]
    associate_public_ip_address = true
    tags = {
      Name="public-ec2"
    }
  
}
resource "aws_instance" "dev2" {
    ami ="ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    subnet_id = aws_subnet.dev2.id
    security_groups = [aws_security_group.dev.id]
    tags = {
        Name = "private-ec2"
    }

}