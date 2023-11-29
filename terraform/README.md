# Terraform Conduktor Deployment

This Terraform configuration will deploy a basic setup of Conduktor into an account of your choice.

A sample tfvars file can be found below:

```hcl
cli_profile_name = "test_env"
region           = "eu-central-1"

owner = "edna.mode@nocapes.com"

vpc_name = "default"

alb_ingress_cidrs = {
  "Home address"  = ["4.3.2.1/32"]
  "Office IPs" = [
    "1.2.3.4/32",
    "5.6.7.8/32
  ]
}

conduktor_console_image_tag    = "1.19.2"
conduktor_monitoring_image_tag = "1.19.2"

conduktor_organization_name = "Test Organization"
conduktor_username          = "edna.mode@nocapes.com"
conduktor_password          = "ineverlookbackdarling"

rds_password = "thisisnotsecretatall"

additional_task_role_policies = [
  "arn:aws:iam::aws:policy/AmazonMSKFullAccess",
  "arn:aws:iam::123456789012:policy/kafka-access"
]
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.conduktor_cluster_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.conduktor_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.conduktor_state_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecs_capacity_provider.conduktor_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.conduktor_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.conduktor_node_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.conduktor_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.conduktor_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.node_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.conduktor_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.conduktor_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_template.conduktor_cluster_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.conduktor_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.conduktor_default_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.conduktor_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_allow_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_allow_to_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_allow_all_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_allow_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_allow_from_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.conduktor_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.conduktor_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.postgres_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.ecs_optimized_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.msk_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.msk_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.msk_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_task_role_policies"></a> [additional\_task\_role\_policies](#input\_additional\_task\_role\_policies) | A list of ARNs to attach to the Task Role for use by the ECS Service.<br>  This should include kafka-cluster (Kafka API) permissions to interact with an MSK cluster. | `list(string)` | `[]` | no |
| <a name="input_alb_ingress_cidrs"></a> [alb\_ingress\_cidrs](#input\_alb\_ingress\_cidrs) | A map of 'description = CIDR ranges' to allow ingress from to the ALB. | `map(list(string))` | <pre>{<br>  "Internet": [<br>    "0.0.0.0/0"<br>  ]<br>}</pre> | no |
| <a name="input_cli_profile_name"></a> [cli\_profile\_name](#input\_cli\_profile\_name) | The name of the AWS CLI profile to deploy this Terraform with.<br>  Set to null to use environment variables instead. | `string` | `null` | no |
| <a name="input_conduktor_console_image_tag"></a> [conduktor\_console\_image\_tag](#input\_conduktor\_console\_image\_tag) | The image tag of the conduktor/conduktor-platform image to use for the console. | `string` | `"1.19.2"` | no |
| <a name="input_conduktor_monitoring_image_tag"></a> [conduktor\_monitoring\_image\_tag](#input\_conduktor\_monitoring\_image\_tag) | The image tag of the conduktor/conduktor-platform-cortex image to use for monitoring. | `string` | `"1.19.2"` | no |
| <a name="input_conduktor_organization_name"></a> [conduktor\_organization\_name](#input\_conduktor\_organization\_name) | The name of the Organization that Conduktor will use. | `string` | `"Test Organization"` | no |
| <a name="input_conduktor_password"></a> [conduktor\_password](#input\_conduktor\_password) | Password for the Conduktor console. | `string` | n/a | yes |
| <a name="input_conduktor_username"></a> [conduktor\_username](#input\_conduktor\_username) | Username for the Conduktor console. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Your name, used for tagging purposes. | `string` | `"Edna Mode"` | no |
| <a name="input_rds_password"></a> [rds\_password](#input\_rds\_password) | Password for the RDS instance that stores the state of Conduktor | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in which to deploy these resources. | `string` | `"eu-west-1"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The Name tag of the VPC to search for. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_conduktor_address"></a> [conduktor\_address](#output\_conduktor\_address) | The URL of the Conduktor console. This will be the Application Load Balancer's DNS name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
