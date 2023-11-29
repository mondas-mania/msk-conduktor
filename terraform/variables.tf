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
  description = "A map of 'description = CIDR ranges' to allow ingress from to the ALB."
  type        = map(list(string))
  default     = { "Internet" = ["0.0.0.0/0"] }
}

variable "additional_task_role_policies" {
  description = <<EOT
  A list of ARNs to attach to the Task Role for use by the ECS Service.
  This should include kafka-cluster (Kafka API) permissions to interact with an MSK cluster.
  EOT
  type        = list(string)
  default     = []
}

variable "conduktor_console_image_tag" {
  description = "The image tag of the conduktor/conduktor-platform image to use for the console."
  type        = string
  default     = "1.19.2"
}

variable "conduktor_monitoring_image_tag" {
  description = "The image tag of the conduktor/conduktor-platform-cortex image to use for monitoring."
  type        = string
  default     = "1.19.2"
}

variable "rds_password" {
  description = "Password for the RDS instance that stores the state of Conduktor"
  type        = string
}

variable "conduktor_username" {
  description = "Username for the Conduktor console."
  type        = string
}

variable "conduktor_password" {
  description = "Password for the Conduktor console."
  type        = string
}