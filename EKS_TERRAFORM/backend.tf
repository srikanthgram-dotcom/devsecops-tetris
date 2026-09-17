terraform {
  backend "s3" {
    bucket = "tertries-devops-terraform-starefile" # Replace with your actual S3 bucket name
    key    = "EKS/terraform.tfstate"
    region = "ap-south-1"
  }
}
