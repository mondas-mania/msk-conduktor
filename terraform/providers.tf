provider "aws" {
  profile = var.cli_profile_name
  region  = var.region

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  alias   = "use1"
  profile = var.cli_profile_name
  region  = "us-east-1"

  default_tags {
    tags = local.default_tags
  }
}
