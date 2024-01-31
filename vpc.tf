#vpc
resource "aws_vpc" "ibm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ibm"
  }
}

#web subnet
resource "aws_subnet" "ibm-web-sn" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "ibm-web-subnet"
  }
}
#Database subnet
resource "aws_subnet" "ibm-db-sn" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch ="false"

  tags = {
    Name = "ibm-database-subnet"
  }
}

#internet gateway
resource "aws_internet_gateway" "ibm-igw" {
  vpc_id = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-internet-gateway"
  }
}
#web route table
resource "aws_route_table" "ibm-web-rt" {
  vpc_id = aws_vpc.ibm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm-igw.id
  }

  
  tags = {
    Name = "ibm-web-route-table"
  }
}
#database route table
resource "aws_route_table" "ibm-database-rt" {
  vpc_id = aws_vpc.ibm-vpc.id

 
  
  tags = {
    Name = "ibm-database-route-table"
  }
}
#websubnet association:
resource "aws_route_table_association" "ibm-web-asc" {
  subnet_id      = aws_subnet.ibm-web-sn.id
  route_table_id = aws_route_table.ibm-web-rt.id
}

#databasesubnet association:
resource "aws_route_table_association" "ibm-database-asc" {
  subnet_id      = aws_subnet.ibm-database-sn.id
  route_table_id = aws_route_table.ibm-database-rt.id
}

#web nacl
resource "aws_network_acl" "ibm-web-nacl" {
  vpc_id = aws_vpc.ibm-vpc.id
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }


  tags = {
    Name = "ibm-web-nacl"
  }
}
#database nacl
resource "aws_network_acl" "ibm-database-nacl" {
  vpc_id = aws_vpc.ibm-vpc.id
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }


  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  

  tags = {
    Name = "ibm-database-nacl"
  }
}
#web-nacl-association
resource "aws_network_acl_association" "ibm-web-nacl-asc" {
  network_acl_id = aws_network_acl.ibm-web-nacl.id
  subnet_id      = aws_subnet.ibm-web-sn.id
}
#database-nacl-associations
resource "aws_network_acl_association" "ibm-database-nacl-asc" {
  network_acl_id = aws_network_acl.ibm-database-nacl.id
  subnet_id      = aws_subnet.ibm-database-sn.id
}
#web security group
resource "aws_security_group" "ibm-web-sg" {
  name        = "ibm-web-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.ibm-vpc.id}"

  ingress {
    description = "TLS from www"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from www"
    from_port   = 80
    to_port     = 80
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
    Name = "ibm-web-sg"
  }
}

#database security group
resource "aws_security_group" "ibm-database-sg" {
  name        = "ibm-database-traffic"
  description = "Allow SSH - postgres inbound traffic"
  vpc_id      = "${aws_vpc.ibm-vpc.id}"

  ingress {
    description = "SSH from www"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "postgress from www"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ibm-database-sg"
  }
}