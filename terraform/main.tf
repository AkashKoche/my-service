resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
  acl    = "private"
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc_main.id
  cidr_block = "10.0.1.0/24"
}


resource "aws_security_group" "ecs" {
  vpc_id = aws_vpc.main.id


  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.main.id


  ingress {
    from_port  = 5432
    to_port    = 5432
    protocol   = "tcp"
    cidr_block = ["10.0.0.0/16"]
  }
}
