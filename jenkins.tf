resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-demo"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0e52cb05dc5201679"

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.110.170.85/32"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins-demo"
  }
}
/* data "template_file" "userdata1" {
  template = file("jenkinsuserdata.sh")

} */
resource "aws_instance" "jenkins" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-01fdf4d4f9eb444d4"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  key_name               = aws_key_pair.deploy.id
  user_data = <<EOF
  #!/bin/bash
    sudo yum upgrade -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo amazon-linux-extras install java-openjdk11 -y
    sudo yum install jenkins -y
    sudo systemctl status jenkins
    sudo systemctl start jenkins
    systemctl enable jenkins
EOF
  tags = {
    Name = "jenkins-demo"
  }

}