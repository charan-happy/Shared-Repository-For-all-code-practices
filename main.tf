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
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  user_data_replace_on_change = true
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP Request"
  type = number
  default = 8080
}

//autoscaling group
resource "aws_launch_configuration" "example" {
  image_id = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  # required when using a launch configuration with an auto scaling group 
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name 

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terraform asg-example"
    propagate_at_launch = true
  }
}
output "public_ip" {
  value = aws_instance.example.public_ip
  description = "the public IP address of the web server"
}