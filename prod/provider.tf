provider "aws" {
  region     = var.aws_region
  access_key = var.prod_access_key
  secret_key = var.prod_secret_key
}

provider "template" {}

provider "null" {}

