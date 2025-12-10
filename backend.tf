terraform {
  backend "s3" {
    bucket = "mypodsix-s3-bucket"
    key    = "mypodsix/prodution/terraform.tfstate"
    region = "us-east-1"
  }
}