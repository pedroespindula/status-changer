terraform {
  backend "s3" {
    bucket = "pagarme-challenge-tfstate"
    key    = "us-east-1/iam-user/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "pagarme-challenge-tflock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "github" {
  name = "github"
  path = "/serviceaccounts/"
}

data "aws_iam_policy" "administrator" {
  name = "AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "github" {
  user       = aws_iam_user.github.name
  policy_arn = data.aws_iam_policy.administrator.arn
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}

output "github_access_key" {
  value       = aws_iam_access_key.github.id
  description = "AWS_ACCESS_KEY to manage AWS resources"
}

output "github_secret_key" {
  value       = aws_iam_access_key.github.secret
  description = "AWS_SECRET_ACCESS_KEY to manage AWS resources"
  sensitive   = true
}
