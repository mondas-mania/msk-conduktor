variable "owner" {
  description = "Your name, used for tagging purposes."
  type        = string
  default     = "Edna Mode"
}

variable "cli_profile_name" {
  description = <<EOT
  The name of the AWS CLI profile to deploy this Terraform with.
  Set to null to use environment variables instead.
  EOT
  type        = string
  default     = null
}

variable "region" {
  description = "The AWS region in which to deploy these resources."
  type        = string
  default     = "eu-west-1"
}

variable "vpc_name" {
  description = "The Name tag of the VPC to search for."
  type        = string
}

variable "alb_ingress_cidrs" {
  description = "A list of CIDR ranges to allow ingress from to the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}