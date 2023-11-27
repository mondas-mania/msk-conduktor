# Terraform Conduktor Deployment

This Terraform configuration will deploy a basic setup of Conduktor into an account of your choice.

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
| [aws_availability_zones.availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cli_profile_name"></a> [cli\_profile\_name](#input\_cli\_profile\_name) | The name of the AWS CLI profile to deploy this Terraform with.<br>  Set to null to use environment variables instead. | `string` | `null` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Your name, used for tagging purposes. | `string` | `"Edna Mode"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in which to deploy these resources. | `string` | `"eu-west-1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
