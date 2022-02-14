terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "vibhuyadav"

    workspaces {
      name = "zelda-dev"
    }
  }
}

