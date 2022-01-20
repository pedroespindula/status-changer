locals {
  aws_region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "pagarme-infra-tfstate"
    key    = "pagarme-infra-tflock"
    region = local.aws_region
  }
}

provider "aws" {
  region = local.aws_region
}
