variable "location" {
  description = "Default region"
  type        = string
  default     = "westeurope"
}

variable "name" {
  description = "Movie Store application"
  type        = string
  default     = "moviestore"
}

variable "storage_prefix" {
  description = "moviestore backend storage"
  type = string
  default = "moviestore"
}

variable "service_principal_name" {
  type = string
  default = "moviestore-serviceprincipal"
}


variable "keyvault_name" {
  type = string
  default = "moviestore-keyvault"
}