terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Las credenciales se toman automáticamente de las variables de entorno:
  # AWS_ACCESS_KEY_ID
  # AWS_SECRET_ACCESS_KEY
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}