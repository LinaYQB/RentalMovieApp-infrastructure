locals {
  name   = "MovieStore"
  location = "westeurope"

  vnet_cidr = "10.123.0.0/16"

  tags = {
    moviestore = local.name
  }
}

