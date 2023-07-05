provider "aws" {
  region = "us-east-1"
  access_key = "AKIAYCMCGKV73DODXFNE"
  secret_key = "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"
  alias = "source"
}

provider "aws" {
  region = "us-west-2"
  access_key = "AKIAYCMCGKV73DODXFNE"
  secret_key = "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"
  alias = "dest"
}

data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_caller_identity" "dest" {
  provider = aws.dest
}