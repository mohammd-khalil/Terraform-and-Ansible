terraform {
  backend "s3" {
    bucket         = "s3-bucket-name"
    key            = "ec2-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
