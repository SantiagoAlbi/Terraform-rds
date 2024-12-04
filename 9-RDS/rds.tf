module "database" {
  source             = "./module/rds"
  project_name       = "project-rds-module"
  security_group_ids = [aws_security_group.compliant.id, aws_security_group.not_compliant.id]
  subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]

  credentials = {
    username = "dbadmin"
    password = "1234Titopraga"
  }
}