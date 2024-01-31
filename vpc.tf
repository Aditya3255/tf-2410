#vpc
resource "aws_vpc" "myntra_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myntra"
  }
}

#web subnet
resource "aws_subnet" "myntra-web-sn" {
  vpc_id     = aws_vpc.myntra-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "Myntra-web-subnet"
  }
}
#Database subnet
resource "aws_subnet" "myntra-db-sn" {
  vpc_id     = aws_vpc.myntra-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch ="false"

  tags = {
    Name = "Myntra-database-subnet"
  }
}
