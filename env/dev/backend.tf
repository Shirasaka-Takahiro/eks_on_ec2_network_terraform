terraform {
  required_version = "1.10.2"
  backend "s3" {
    bucket = "example-dev-tfstate-bucket"
    region = "ap-northeast-1"
    key    = "dev.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}