variable "extra_tags" {
  description = "Set of extra tags to be added to the module resources."
  type        = map(string)
}

variable "app_runner_instance_arns" {
  description = "Map of service configurations to create the appropriate AWS Apprunner service."
  type        = map(string)
}

variable "ecr_access_arn" {
  description = "ARN of ECR access role that gives App Runner permission to access ECR."
  type        = string
}

variable "vpc_connector_configuration" {
  description = "A map of VPC connector configurations for services."
  type = map(object({
    egress_configuration = optional(object({
      subnets         = list(string)
      security_groups = list(string)
    }))
  }))
}
variable "services" {
  description = "A map of services to be deployed"
  type = map(object({
    image_repository_type    = string
    vpc_connector_name       = optional(string)
    service_name             = string
    repository_name          = string
    auto_deployments_enabled = bool
    image_identifier = object({
      ecr_repository_url = string
      image_tag          = string
    })
    image_configuration = object({
      port                          = string
      runtime_environment_variables = optional(map(string))
      runtime_environment_secrets   = optional(map(string))
      start_command                 = optional(string)
    })
    instance_configuration = object({
      cpu    = string
      memory = string
    })
    observability   = optional(bool)
    public_endpoint = optional(bool)
    custom_domain = optional(object({
      domain_name          = string
      enable_www_subdomain = bool
    }))
    health_check_configuration = optional(object({
      protocol            = string
      healthy_threshold   = number
      unhealthy_threshold = number
      interval            = number
      path                = string
      timeout             = number
    }))
    autoscaling_config_name = string
  }))
}

variable "vpc" {
  description = "AWS VPC of the current environment."
}

variable "interface_endpoint" {
  description = "AWS VPC interface endpoint to be added to the private apprunner services."
}

variable "auto_scaling_configurations" {
  description = "Map of common autoscaling configurations for services."
  type = map(object({
    name            = string
    max_concurrency = number
    max_size        = number
    min_size        = number
    tags            = map(string)
  }))
}
