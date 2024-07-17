resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  
}
resource "aws_internet_gateway" "myIG" {
  vpc_id = aws_vpc.my-vpc.id
}
resource "aws_subnet" "publicsubnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.my-vpc.id
  
}
resource "aws_subnet" "privatesubnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_route_table" "RT1" {
  vpc_id = aws_vpc.my-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id =aws_internet_gateway.myIG.id
  }
}
resource "aws_route_table_association" "RT1" {
  route_table_id = aws_route_table.RT1.id
  subnet_id = aws_subnet.publicsubnet.id
}
resource "aws_nat_gateway" "my-NAT" {
  allocation_id = aws_eip.NAT.id
  connectivity_type = "public"
  subnet_id = aws_subnet.publicsubnet.id
  tags = {
    Name ="NAT"
  }
}
resource "aws_eip" "NAT" {
  domain = "vpc"
}
resource "aws_route_table" "RT2" {
  vpc_id = aws_vpc.my-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-NAT.id
  }
}
resource "aws_route_table_association" "RT2" {
  route_table_id = aws_route_table.RT2.id
  subnet_id = aws_subnet.privatesubnet.id
}
resource "aws_security_group" "SG2" {
  vpc_id = aws_vpc.my-vpc.id
  description = "securitygroups"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}
resource "aws_instance" "pub" {
  ami = "ami-013a28d7c2ea10269"
  instance_type = "t2.micro"
  key_name = "keypair2"
  subnet_id = aws_subnet.publicsubnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.SG2.id]
  tags = {
    Name = "ec2"
  }
  
}
resource "aws_instance" "pri" {
  ami = "ami-013a28d7c2ea10269"
  instance_type = "t2.micro"
  key_name = "keypair2"
  subnet_id = aws_subnet.privatesubnet.id
  vpc_security_group_ids = [aws_security_group.SG2.id]
  tags = {
    Name = "privateec2"
  }
  
}





