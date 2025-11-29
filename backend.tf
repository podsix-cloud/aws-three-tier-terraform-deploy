terraform {
  backend "s3" {
    bucket = "pod-6-project"
    key    = "mypodsix/prodution/terraform.tfstate"
    region = "eu-north-1"
  }
}