#vpc
resource "aws_vpc" "myntra_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myntra"
  }
}

#web subnet
resource "aws_subnet" "myntra_web_sn" {
  vpc_id     = aws_vpc.myntra_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "Myntra_web_subnet"
  }
}
#Database subnet
resource "aws_subnet" "myntra_db_sn" {
  vpc_id     = aws_vpc.myntra_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch ="false"

  tags = {
    Name = "Myntra_database_subnet"
  }
}

#internet gateway
resource "aws_internet_gateway" "myntra_igw" {
  vpc_id = aws_vpc.myntra_vpc.id

  tags = {
    Name = "myntra_internet_gateway"
  }
}
