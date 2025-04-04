resource "aws_db_instance" "microservice" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgre"
  engine_version          = "13.6"
  instance_class          = "db.t3.micro"
  db_name                 = "mydatabase"
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.postgre13"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.private.name
}


resource "aws_db_subnet_group" "private" {
  name       = "private-subnet-group"
  subnet_ids = [aws_subnet.private.id]
}
