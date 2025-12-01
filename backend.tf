terraform {
  backend "s3" {
    bucket = "podsix-s3-bucket01"
    key    = "mypodsix/prodution/terraform.tfstate"
    region = "us-east-1"
  }
}