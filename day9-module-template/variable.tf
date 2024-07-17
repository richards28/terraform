variable "ami" {
    default = "ami-013a28d7c2ea10269"
    type = string
    description = "ami id description"
}
variable "type" {
    default = "t2.micro"
    type = string
    description = "type of instance"
}
variable "key" {
    default = "keypair2"
    type = string
  
}