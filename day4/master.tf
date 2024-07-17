 #for vpc
 resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-vpc"
    }
}
#for IG
resource "aws_internet_gateway" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
     Name = "IG"
    }
  
}

#for subnet
resource "aws_subnet" "dev" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-subnet"
  }
}
#for route table and connecting to IG
resource "aws_route_table" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "my-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }
}
#for subnet associations
resource "aws_route_table_association" "dev" {
  subnet_id      = aws_subnet.dev.id
  route_table_id = aws_route_table.dev.id
}
#for security group
resource "aws_security_group" "dev" {
  vpc_id = aws_vpc.dev.id
  name = "mysecuritygroup"
  description = "inboundrules"
  ingress  {
    from_port = 22
    to_port =22
    protocol="tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =["0.0.0.0/0"]
  }
}

resource "aws_instance" "name" {
  ami = "ami-03350e4f182961c7f"
  instance_type ="t2.micro"
  key_name = "keypair2"
  subnet_id = aws_subnet.dev.id
  security_groups = [aws_security_group.dev.id]
  tags = {
    Name = "ec22"
  }
  
}









