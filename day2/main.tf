#create vpc
resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-VPC"
    }
}
#create IG and attach to vpc
resource "aws_internet_gateway" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
        Name="IG"
    }
}
#create public subnet
resource "aws_subnet" "dev" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.0.0/24"
    tags ={
        Name = "publicsubnet"
    }
}
#create route table and attach to IG
resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
        Name ="RT1"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev.id
    }
}
#attach subnet to route table
resource "aws_route_table_association" "dev" {
    subnet_id = aws_subnet.dev.id
    route_table_id = aws_route_table.dev.id
}
#create security group
resource "aws_security_group" "dev" {
    vpc_id = aws_vpc.dev.id
    name = "allow_traffic"
    description = "my security group rules"
    tags = {
        Name = "sg22"
    }
    ingress {
        from_port = 22
        to_port =22
        protocol="tcp"
        cidr_blocks= ["0.0.0.0/0"]
    }
    egress  {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks= ["0.0.0.0/0"]
    }
}
#create public subnet
resource "aws_subnet" "dev2" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "privatesubnet"
    }
}
#create Nat gateway,allocate eip and attach to public subnet
resource "aws_nat_gateway" "dev" {
    allocation_id = aws_eip.dev.id
    connectivity_type = "public"
    subnet_id = aws_subnet.dev.id
    tags = {
      Name ="NAT"
    }
}
#define eip
resource "aws_eip" "dev"{
    domain = "vpc"
}
#create routetble2 and attach to nat 
resource "aws_route_table" "dev2" {
    vpc_id = aws_vpc.dev.id
    tags = {
      cidr_block = "0.0.0.0/0"
      gateway_id=aws_nat_gateway.dev.id
    }
}
#attach subnet to routetable2
resource "aws_route_table_association" "dev2" {
    subnet_id = aws_subnet.dev2.id
    route_table_id = aws_route_table.dev2.id
  
}
#ec2 public 
resource "aws_instance" "dev" {
    ami = "ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    security_groups = [aws_security_group.dev.id]
    subnet_id = aws_subnet.dev.id
    associate_public_ip_address = true
    tags = {
        Name = "publicec2"
    }
}
#ec2 private
resource "aws_instance" "dev2" {
    ami = "ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    security_groups = [aws_security_group.dev.id]
    subnet_id = aws_subnet.dev2.id
    tags= {
        Name = "privateec2"
    }
}
