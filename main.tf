terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {

  region = "us-east-1"

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check = true

  s3_use_path_style = true

  endpoints {

    s3 = "http://host.docker.internal:4566"
    dynamodb = "http://host.docker.internal:4566"
    iam = "http://host.docker.internal:4566"

  }

}

resource "aws_dynamodb_table" "lock" {

  name = "tf-lock"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

