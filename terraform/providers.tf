provider "aws" {
  profile = var.cli_profile_name
  region  = var.region

  default_tags {
    tags = local.default_tags
  }
}
