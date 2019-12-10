provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {}
}

resource "aws_instance" "example" {
  ami           = "ami-00068cd7555f543d5"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum -y install httpd
              sudo service httpd start  
              echo "Hello, World" > /var/www/html/index.html
              EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}