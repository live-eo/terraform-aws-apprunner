# terraform-aws-appruner

## Description
This Terraform module deploys AWS App Runner services using given configurations and the provided ECR image. It includes automatic creation of necessary VPC connectors for private VPC access, and auto-scaling configurations for handling changes in demand. It outputs the ARNs and URLs of deployed services for easy integration with other services and systems.

#### Features
- **Flexible App Runner service configuration**: Each App Runner service can be customized by providing a corresponding set of parameters, including image repository details, health check configurations, instance configurations, and more.
- **VPC connectors**: Enables AWS App Runner services to access resources within a private VPC by automatically creating VPC connectors for each service.
- **Auto-scaling**: Uses App Runner's built-in auto-scaling feature to scale each service based on demand, ensuring optimal resource usage and performance.
- **Health checks**: Allows enabling and configuring health checks for each service, ensuring that AWS can monitor the health of the service and replace instances as needed.
- **Private Endpoints**: Ability to make the App Runner service accessible through private endpoints only. This ensures that the service is not exposed to the public internet and can only be accessed from within the specified VPC.
- **AWS Secrets as Environment Variables**: Passing AWS secrets as environment varaibles, such as API keys, access credentials, or sensitive configuration information, to your App Runner services as environment variables. This allows your applications to securely access the required secrets without exposing them directly in the code or configuration.
- **Tagging**: Every resource that supports tagging gets a set of tags for easy filtering and management.
- **Custom Domain** : Ability to create custom domain enpoints for each apprunner service, which can be added to route 53 for routing


---

## Setup/Installation

Create a virtual environment and install requirements.
```
sudo apt install snapd
sudo snap install go --classic
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.dev.txt
pre-commit install
```

### Requirements
 - pip


## Usage
 - The `terraform-aws-appruner` is an independent Terraform module designed to be applied per cloud environment. This approach provides greater flexibility and granularity in deploying App Runner services across various environments (e.g., dev, test, prod). The module requires certain inputs from the modules `terraform-aws-appruner`, `terraform-aws-service-role` and provides a number of outputs which can be leveraged for further integration with other services.
 - Example of the module usage are placed in the example folder

## Editing this README

To edit this readme, please consider the [ReadMe support template](https://live-eo.atlassian.net/wiki/spaces/TS/pages/271417421/Readme+Support+Template) confluence page

---

## Roadmap

Future releases will depend on Cloud/Beehive deployment needs.

---

## Project status

Development is progressive for this module, as development is needed for both Cloud and Beehive repositories.

---

## Support

### <p id="contributors"> Contributors: </p>
- Anirban Deb ([anirban.deb@live-eo.com](mailto:anirban.deb@live-eo.com))

### <p id="maintainer">Maintainer: </p>
 - Infra

 For further inquiries, please send a message on the Infra slack channel and tag the [contributors](#contributors) listed above.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.51 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.51 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apprunner_auto_scaling_configuration_version.common_autoscaling_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_auto_scaling_configuration_version) | resource |
| [aws_apprunner_custom_domain_association.custom_domain_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_custom_domain_association) | resource |
| [aws_apprunner_observability_configuration.app_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_observability_configuration) | resource |
| [aws_apprunner_service.app_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service) | resource |
| [aws_apprunner_vpc_connector.app_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_vpc_connector) | resource |
| [aws_apprunner_vpc_ingress_connection.app_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_vpc_ingress_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_runner_instance_arns"></a> [app\_runner\_instance\_arns](#input\_app\_runner\_instance\_arns) | Map of service configurations to create the appropriate AWS Apprunner service. | `map(string)` | n/a | yes |
| <a name="input_auto_scaling_configurations"></a> [auto\_scaling\_configurations](#input\_auto\_scaling\_configurations) | Map of common autoscaling configurations for services. | <pre>map(object({<br>    name            = string<br>    max_concurrency = number<br>    max_size        = number<br>    min_size        = number<br>    tags            = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_core"></a> [core](#input\_core) | Set of variables that are needed in all Cloud modules. | <pre>object({<br>    cloud_prefix = string,<br>    region       = string,<br>    deployment = object({<br>      customer = string,<br>      cloud    = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_ecr_access_arn"></a> [ecr\_access\_arn](#input\_ecr\_access\_arn) | ARN of ECR access role that gives App Runner permission to access ECR. | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Set of extra tags to be added to the module resources. | `map(string)` | n/a | yes |
| <a name="input_interface_endpoint"></a> [interface\_endpoint](#input\_interface\_endpoint) | AWS VPC interface endpoint to be added to the private apprunner services. | `any` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | A map of services to be deployed | <pre>map(object({<br>    image_repository_type    = string<br>    vpc_connector_name       = optional(string)<br>    service_name             = string<br>    repository_name          = string<br>    auto_deployments_enabled = bool<br>    image_identifier = object({<br>      ecr_repository_url = string<br>      image_tag          = string<br>    })<br>    image_configuration = object({<br>      port                          = string<br>      runtime_environment_variables = optional(map(string))<br>      runtime_environment_secrets   = optional(map(string))<br>      start_command                 = optional(string)<br>    })<br>    instance_configuration = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    observability   = optional(bool)<br>    public_endpoint = optional(bool)<br>    custom_domain = optional(object({<br>      domain_name          = string<br>      enable_www_subdomain = bool<br>    }))<br>    health_check_configuration = optional(object({<br>      protocol            = string<br>      healthy_threshold   = number<br>      unhealthy_threshold = number<br>      interval            = number<br>      path                = string<br>      timeout             = number<br>    }))<br>    autoscaling_config_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | AWS VPC of the current environment. | `any` | n/a | yes |
| <a name="input_vpc_connector_configuration"></a> [vpc\_connector\_configuration](#input\_vpc\_connector\_configuration) | A map of VPC connector configurations for services. | <pre>map(object({<br>    egress_configuration = optional(object({<br>      subnets         = list(string)<br>      security_groups = list(string)<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_runner_config"></a> [app\_runner\_config](#output\_app\_runner\_config) | Map of app runner config for monitoring system. |
| <a name="output_custom_domain_certificate_validation_records"></a> [custom\_domain\_certificate\_validation\_records](#output\_custom\_domain\_certificate\_validation\_records) | The certificate validation records for the custom domain associations. |
| <a name="output_custom_domain_dns_targets"></a> [custom\_domain\_dns\_targets](#output\_custom\_domain\_dns\_targets) | The DNS targets for the custom domain associations. |
| <a name="output_custom_domain_ids"></a> [custom\_domain\_ids](#output\_custom\_domain\_ids) | The IDs for the custom domain associations. This includes the domain\_name and service\_arn separated by a comma. |
| <a name="output_service_arns"></a> [service\_arns](#output\_service\_arns) | The ARNs of the deployed services. |
| <a name="output_service_urls"></a> [service\_urls](#output\_service\_urls) | The URLs of the deployed services. |
| <a name="output_vpc_connector_arn"></a> [vpc\_connector\_arn](#output\_vpc\_connector\_arn) | The ARN for the newly created VPC connector for each service. |
<!-- END_TF_DOCS -->
