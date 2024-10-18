provider "aws" {
  region = "us-east-1"
}
/*
- AWS has datacenters across the globe and they are grouped into regions. An AWS region is a separate geographical area, such as us-east-1, us-east-2, ohio etc. and within each region, there are multiple isolated datacenters known as "Availability zones (AZ)" such as us-east-1a, us-east-2a 
*/

resource "aws_instance" "example" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example-instance"
  }
}