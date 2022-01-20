locals {
  aws_region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "pagarme-infra-tfstate"
    key    = "pagarme-infra-tflock"
    region = "us-east-1"
  }
}

provider "aws" {
  region = local.aws_region
}
