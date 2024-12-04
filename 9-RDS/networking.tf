data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Project-rds"
  }
}
moved {
  from = aws_subnet.allowed
  to   = aws_subnet.private1
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name   = "Subnet-custom-vpc-1"
    Access = "private"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name   = "Subnet-custom-vpc-2"
    Access = "private"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name   = "Subnet-custom-vpc-public"
    Access = "public"
  }
}



#FOR DOCUMENTATION/NOT IN USE
resource "aws_subnet" "not_allowed" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.128.0/24"

  tags = {
    Name = "Subnet-default-vpc"
  }
}

########## 
# SECURITY GROUPS
##########

resource "aws_security_group" "source" {
  name        = "source-sg"
  description = "SG connections are allowed into DB"
  vpc_id      = aws_vpc.custom.id #de no dar vpc_id se deploya en la default vpc
}

resource "aws_security_group" "compliant" {
  name        = "compliant-sg"
  description = "compliant-SG"
  vpc_id      = aws_vpc.custom.id #de no dar vpc_id se deploya en la default vpc
}

resource "aws_security_group" "not_compliant" {
  name        = "non-compliant-SG"
  description = "non_compliant-SGB"
  vpc_id      = aws_vpc.custom.id #de no dar vpc_id se deploya en la default vpc
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.compliant.id
  referenced_security_group_id = aws_security_group.source.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.not_compliant.id
  #referenced_security_group_id = aws_security_group.source.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 433
  to_port     = 433
  ip_protocol = "tcp"
}