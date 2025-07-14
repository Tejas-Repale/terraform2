terraform {
  backend "s3" {
    bucket         = "terraform-prod-state-bucket-01"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
