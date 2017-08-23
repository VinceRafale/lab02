terraform {
  backend "s3" {
    bucket = "tfstate-lab02"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}
