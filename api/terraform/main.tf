terraform {
  backend "s3" {
    bucket = "pagarme-infra-tfstate"
    key    = "pagarme-infra-tflock"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

module "ecs" {
  source = "./modules/ecs"

  name = "status-changer"

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  aws_tags = var.aws_tags
}
