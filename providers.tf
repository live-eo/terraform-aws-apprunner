terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.51"
    }
  }
}

provider "aws" {
  region = var.core.region
  default_tags {
    tags = var.extra_tags
  }
}
