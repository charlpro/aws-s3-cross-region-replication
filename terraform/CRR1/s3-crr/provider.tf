terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.28"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "enterAccesKeyHere"
  secret_key = "enterSecretKeyHere"
}