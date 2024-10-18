provider "aws" {
  region = "us-east-1"
}
/*
- AWS has datacenters across the globe and they are grouped into regions. An AWS region is a separate geographical area, such as us-east-1, us-east-2, ohio etc. and within each region, there are multiple isolated datacenters known as "Availability zones (AZ)" such as us-east-1a, us-east-2a 
*/

resource "aws_instance" "example" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "terraform-example-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  user_data_replace_on_change = true
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}