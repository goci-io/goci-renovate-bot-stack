terraform {
  backend "s3" {}
}

provider "kubernetes" {
  version          = "~> 1.11"
  load_config_file = false
}
