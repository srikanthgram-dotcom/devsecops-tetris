terraform {
  backend "s3" {
    bucket       = "srikanthgram-devsecops-tetris-state-20260918"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
