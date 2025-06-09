provider "aws" {
  region = var.aws_region
  # Credentials are pulled from environment or ~/.aws/credentials
}
