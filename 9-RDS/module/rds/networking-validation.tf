# SUBNET VALIDATION #

data "aws_vpc" "default" {
  default = true
}

/* data "aws_subnet" "input" {
  for_each = toset(var.subnet_ids)
  id       = each.value

  lifecycle {
    postcondition {
      condition     = self.vpc_id != data.aws_vpc.default.id
      error_message = "The following subnet is part of the defaul VPC Name = ${self.tags.Name}, ID = ${self.id}"
    }

    postcondition {
      condition = can(lower(self.tags.Access) == "private")
      error_message = "NO esta bien el tag macho"
    }
  }
}
 */

# SECURITY GROUP VALIDATION #

data "aws_vpc_security_group_rules" "input" {
  filter {
    name = "group-id"
    values = var.security_group_ids
  }
} 

/* data "aws_vpc_security_group_rule" "input" {
  for_each = toset(data.aws_vpc_security_group_rules.input.ids)
  security_group_rule_id = each.value

  /*  filter {
    name = "group-id"
    values = var.security_group_ids
  } 
 
  lifecycle {
    postcondition {
      condition = (
        self.is_egress 
        ? true
        : self.cidr_ipv4 == null 
        && self.cidr_ipv6 == null 
        #&& self.referenced_security_group_id != null
        )
      error_message = "The following SG contains invalid inbound rule"
    }
  }
}
 */