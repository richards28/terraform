module "dem" {
    source = "github.com/richards28/terraform/day9-module-template"
    ami=  "ami-013a28d7c2ea10269"
    type="t2.micro"
    key="keypair2"
}