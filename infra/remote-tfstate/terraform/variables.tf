variable "bucket_name" {
  description = "Bucket name for the S3 bucket that will be deployed."
  type        = string
  default     = "pagarme-challenge-infra-tfstate"
}

variable "table_name" {
  description = "Table name for the dynamo DB table that will be deployed."
  type        = string
  default     = "pagarme-challenge-infra-tflock"
}
