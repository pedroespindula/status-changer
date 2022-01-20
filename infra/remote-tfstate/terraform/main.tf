provider "aws" {
  region = "us-east-1"
}

module "remote-tfstate" {
  source = "./modules/remote-tfstate"

  bucket_name = var.bucket_name
  table_name  = var.table_name
}
