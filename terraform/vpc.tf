resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform-vpc"
  }
}

resource "aws_subnet" "vpc_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Terraform-Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-IGW"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Terraform-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.vpc_subnet.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_security_group" "Allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh  inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_port80" {
  name        = "allow_port80"
  description = "Allow port 80 inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow_port80"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_0" {
  security_group_id = aws_security_group.Allow_ssh.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0

  tags = {
    Name = "egress 0"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_22" {
  security_group_id = aws_security_group.Allow_ssh.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  tags = {
    Name = "Ingress 22"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_80" {
  security_group_id = aws_security_group.allow_port80.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  tags = {
    Name = "Ingress 80"
  }
}
resource "aws_vpc_security_group_ingress_rule" "ingress_8080" {
  security_group_id = aws_security_group.allow_port80.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  tags = {
    Name = "Ingress 80"
  }
}

resource "aws_eip" "iep" {
  depends_on = [aws_internet_gateway.gw]
  domain     = "vpc"
  instance   = aws_instance.vm.id
}
