terraform {
  backend "s3" {
    bucket = "dev.shp.akoya.statestore"
    key    = "terraform/vibhu_rds_test.tfstate"
    region = "us-east-1"
  }
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "vibhuyadav"

    workspaces {
      name = "zelda-dev"
    }
  }
}

