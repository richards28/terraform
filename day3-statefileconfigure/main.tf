
resource "aws_dynamodb_table" "dynamodbterraform" {
    name = "terro"
    hash_key = "ID"
    read_capacity = 20
    write_capacity = 20
    attribute {
      name = "ID"
      type = "S"
    }
    
}

resource "aws_instance" "dev" {
    ami = "ami-03350e4f182961c7f"
    instance_type = "t2.micro"
    key_name = "keypair2"
    tags = {
      Name ="ec42"
    }
  
}