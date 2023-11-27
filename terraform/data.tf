data "aws_region" "current" {}

data "aws_availability_zones" "availability_zones" {
  filter {
    name   = "region-name"
    values = [data.aws_region.current.name]
  }
}
