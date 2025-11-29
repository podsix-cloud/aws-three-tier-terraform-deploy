terraform {
  backend "s3" {
    bucket = "podsix-s3-bucket"
    key    = "mypodsix/prodution/terraform.tfstate"
    region = "eu-north-1"
  }
}