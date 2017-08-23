terraform {
  backend "s3" {
    bucket = "tfstate-lab02"
    key    = "webapp/terraform.tfstate"
    region = "eu-west-1"
  }
}
