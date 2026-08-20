terraform {
  backend "s3" {
    bucket         = "my-tf-s3bucket-2026"
    key            = "ec2-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
