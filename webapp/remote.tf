data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "tfstate-lab02"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}
