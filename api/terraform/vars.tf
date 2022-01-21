variable "aws_region" {
  description = "AWS region that will be used to deploy the infrastructure"
  type        = string
  default     = "us-east-1"

  validation {
    condition = contains([
      "us-east-2",
      "us-east-1",
      "us-west-1",
      "us-west-2",
      "af-south-1",
      "ap-east-1",
      "ap-south-1",
      "ap-northeast-3",
      "ap-northeast-2",
      "ap-southeast-1",
      "ap-southeast-2",
      "ap-northeast-1",
      "ca-central-1",
      "cn-north-1",
      "cn-northwest-1",
      "eu-central-1",
      "eu-west-1",
      "eu-west-2",
      "eu-west-3",
      "eu-north-1",
      "eu-south-1",
      "me-south-1",
      "sa-east-1",
      "us-gov-west-1",
      "us-gov-east-1"
    ], var.aws_region)
    error_message = "The aws_region must be a valid AWS region."
  }
}

variable "aws_tags" {
  description = "AWS tags that will be shared bettween the deployed resources"
  type = object({
    Owner           = string
    Product         = string
    Team            = string
    Squad           = string
    Service         = string
    User            = string
    ApplicationName = string
    Environment     = string
  })
}

