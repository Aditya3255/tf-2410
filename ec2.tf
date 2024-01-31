#web server
resource "aws_instance" "example" {
  ami           = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.micro"
  key_name = "mumbai"
  subnet_id     = aws_subnet.ibm-web-sn.id
  vpc_security_group_ids = aws_security_group.ibm-web-sg.id
  user_data = file("ecomm.sh")


  tags = {
    Name = "ibm-web-server"
    }

}