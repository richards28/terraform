resource "aws_vpc" "demo" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-vpc"
    } 
}
resource "aws_internet_gateway" "demo" {
    vpc_id = aws_vpc.demo.id
    tags = {Name = "IG"}
}
resource "aws_subnet" "demo" {
    vpc_id = aws_vpc.demo.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "public"
    }
}
resource "aws_subnet" "demopri" {
    vpc_id = aws_vpc.demo.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "privatesubnet"
        }
}
resource "aws_route_table" "demo" {
    vpc_id = aws_vpc.demo.id
    tags = { Name = "RT"}
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo.id
    }
}
resource "aws_route_table_association" "demo" {
    subnet_id = aws_subnet.demo.id
    route_table_id = aws_route_table.demo.id 
}
resource "aws_nat_gateway" "demopri" {
    subnet_id = aws_subnet.demo.id
    allocation_id = aws_eip.demopri.id
    connectivity_type = "public"
    tags = {Name = "MYNAT"}
}
resource "aws_eip" "demopri" {
    domain = "vpc"
}
resource "aws_route_table" "demopri" {
    vpc_id = aws_vpc.demo.id
    tags = {Name = "RT2"}
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.demopri.id
    } 
}
resource "aws_route_table_association" "demopri" {
    subnet_id = aws_subnet.demopri.id
    route_table_id = aws_route_table.demopri.id
}
resource "aws_security_group" "demo" {
    vpc_id = aws_vpc.demo.id
    name = "allow tlc"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol ="-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}
resource "aws_instance" "dev" {
    ami = "ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    subnet_id = aws_subnet.demo.id
    security_groups = [aws_security_group.demo.id]
    associate_public_ip_address = true
    tags = {
        Name = "publicec2"
    }
  
}
resource "aws_instance" "demopri" {
    ami = "ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    subnet_id = aws_subnet.demopri.id
    security_groups = [aws_security_group.demo.id]
    tags = {
      Name = "privateec2"
    }
}