resource "aws_security_group" "apache" {
  name        = "apache-sg"
  description = "this is using for securitygroup"
  vpc_id      = "vpc-0e52cb05dc5201679"

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.110.170.85/32"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 80
    to_port     = 80
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache-sg"
  }

}
resource "aws_instance" "apache" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-01fdf4d4f9eb444d4"
  vpc_security_group_ids = [aws_security_group.apache.id]
  key_name               = aws_key_pair.deploy.id
  user_data              = <<EOF
         #!/bin/bash
         yum update -y
         yum install httpd -y 
         systemctl enable httpd
         systemctl start httpd
       EOF
  tags = {
    Name = "stage-apache"
  }
}