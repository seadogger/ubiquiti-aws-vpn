data "aws_ami" "amzn_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

/*
443 for privatelink cloudwatch logs
*/
resource "aws_security_group" "usg_vpn_sg" {
  name        = "usg-vpn-sg"
  description = "Allow ssh, icmp, syslog"
  vpc_id      = aws_vpc.usg_dev.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.usg_cidr]
  }

  ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.usg_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.env
  }
}

/*
resource "aws_key_pair" "vm-key" {
  key_name   = var.vm-key-name 
  public_key = var.prod_access_key
}
*/

/*
Instantiate ec2instance with
*/
resource "aws_instance" "monocleCam" {
  ami           = data.aws_ami.amzn_linux.id
  instance_type = "t2.micro"
  key_name      = var.vm-key-name
  private_ip    = var.monocle_cam_ip
  subnet_id     = aws_subnet.sn1.id

  vpc_security_group_ids = [aws_security_group.usg_vpn_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.siem_instance_profile.id

  tags = {
    Name = "Monocle_Cam_Server"
  }
}