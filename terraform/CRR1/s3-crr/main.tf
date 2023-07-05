provider "aws" {
  region = "us-east-1"
  access_key = "enterAccesKeyHere"
  secret_key = "enterSecretKeyHere"
  alias = "source"
}

provider "aws" {
  region = "us-west-2"
  access_key = "enterAccesKeyHere"
  secret_key = "enterSecretKeyHere"
  alias = "dest"
}

data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_caller_identity" "dest" {
  provider = aws.dest
}