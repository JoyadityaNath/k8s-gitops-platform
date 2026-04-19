terraform {
  required_providers {
    aws={
        source="hashicorp/aws"
        version="6.38.0"
    }
  }
  backend "s3" {
    bucket = "k8s-gitops-platform-tf-backend"
    key="state/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}


provider "aws" {
  region = "ap-south-1"
}





