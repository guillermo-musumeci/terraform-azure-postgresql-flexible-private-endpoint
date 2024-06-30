########################
## Database Variables ##
########################

variable "postgres_user" {
  type        = string
  description = "The username for PostgreSQL administrator login"
  default     = "dbadmin"
}

variable "postgres_password" {
  type        = string
  description = "The password for PostgreSQL administrator login"
}

variable "postgres_server_sku" {
  type        = string
  description = "PostgreSQL server type"
  default     = "B_Standard_B1ms"
}

variable "postgres_server_version" {
  type        = string
  description = "PostgreSQL server version (Possible values are 11, 12, 13, 14, 15 and 16)"
  default     = "16"
}

variable "postgres_server_storage_mb" {
  type        = number
  description = "PostgreSQL server storage in MB (Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216 and 33553408)"
  default     = 32768
}

variable "postgres_server_storage_tier" {
  type        = string
  description = "PostgreSQL server storage tier (Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80)"
  default     = "P4"
}

variable "postgres_admin_access_cidr" {
  type        = string
  description = "PostgreSQL admin access CIDR"
  default     = "0.0.0.0/0"
}

variable "postgres_database_collation" {
  type        = string
  description = "Specifies the Collation for the Azure PostgreSQL Flexible Server Database"
  default     = "en_US.utf8"
}

variable "postgres_database_charset" {
  type        = string
  description = "Specifies the charset for the Azure PostgreSQL Flexible Server Database"
  default     = "UTF8"
}

