variable "project_name" {
  type = string
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance class of this project"

  validation {
    condition     = contains(["db.t3.micro"], var.instance_class)
    error_message = "Not in free tier, only db.t3.micro"
  }
}

variable "storage_size" {
  type        = number
  default     = 10
  description = "Storage to allocate the DB"

  validation {
    condition     = var.storage_size > 5 && var.storage_size <= 10
    error_message = "DB must be between 5 to 10"
  }
}

variable "engine" {
  type        = string
  default     = "postgres-latest"
  description = "Engine in use, postgres only"

  # validation {
  #  condition = contains(["postgres-latest" , "postgres-14"] var.engine)
  # error_message = "DB engine must be postgres"
  #}
}

variable "credentials" {
  type = object({
    username = string
    password = string
  })

  sensitive = true

  validation {
    condition = (
      length(regexall("[a-aZ-Z]+", var.credentials.password)) > 0
      && length(regexall("[0-9]+", var.credentials.password)) > 0
      && length(regexall("[a-zA-Z0-9]{6,}", var.credentials.password)) > 0
    )
    error_message = "Cambia la contrasena macho"
  }
}

######################
# DB network
######################

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs to deploy RDS Instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "SG IDs attached to RDS instance in"
}

