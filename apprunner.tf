resource "aws_apprunner_service" "app_service" {
  for_each = var.services

  service_name = each.value.service_name

  source_configuration {
    auto_deployments_enabled = each.value.auto_deployments_enabled

    dynamic "authentication_configuration" {
      for_each = each.value.image_repository_type == "ECR" ? [1] : []
      content {
        access_role_arn = var.ecr_access_arn
      }
    }

    image_repository {
      image_identifier      = "${each.value.image_identifier.ecr_repository_url}:${each.value.image_identifier.image_tag}"
      image_repository_type = each.value.image_repository_type

      dynamic "image_configuration" {
        for_each = each.value.image_configuration != null ? [each.value.image_configuration] : []
        content {
          port                          = lookup(image_configuration.value, "port", null)
          runtime_environment_variables = lookup(image_configuration.value, "runtime_environment_variables", null)
          runtime_environment_secrets   = lookup(image_configuration.value, "runtime_environment_secrets", null)
          start_command                 = lookup(image_configuration.value, "start_command", null)
        }
      }
    }
  }

  dynamic "health_check_configuration" {
    for_each = each.value.health_check_configuration != null ? [each.value.health_check_configuration] : []
    content {
      healthy_threshold   = lookup(health_check_configuration.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check_configuration.value, "unhealthy_threshold", null)
      interval            = lookup(health_check_configuration.value, "interval", null)
      path                = lookup(health_check_configuration.value, "path", null)
      protocol            = lookup(health_check_configuration.value, "protocol", null)
      timeout             = lookup(health_check_configuration.value, "timeout", null)
    }
  }

  instance_configuration {
    instance_role_arn = var.app_runner_instance_arns[each.value.service_name]
    cpu               = each.value.instance_configuration.cpu
    memory            = each.value.instance_configuration.memory
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.common_autoscaling_config[var.services[each.key].autoscaling_config_name].arn

  dynamic "network_configuration" {
    #for_each = each.value.vpc_connector_name != null ? (var.vpc_connector_configuration[each.value.vpc_connector_name] != null ? [1] : []) : []
    for_each = (each.value.vpc_connector_name != null && var.vpc_connector_configuration[each.value.vpc_connector_name] != null) ? [1] : []

    content {
      dynamic "egress_configuration" {
        for_each = var.vpc_connector_configuration[each.value.vpc_connector_name] != null && var.vpc_connector_configuration[each.value.vpc_connector_name].egress_configuration != null ? [var.vpc_connector_configuration[each.value.vpc_connector_name].egress_configuration] : []
        content {
          egress_type = "VPC"
          #vpc_connector_arn = var.vpc_connector_configuration[each.value.vpc_connector_name] != null ? aws_apprunner_vpc_connector.app_service[each.key].arn : null
          vpc_connector_arn = var.vpc_connector_configuration[each.value.vpc_connector_name] != null ? aws_apprunner_vpc_connector.app_service[each.value.vpc_connector_name].arn : null
        }
      }
      dynamic "ingress_configuration" {
        for_each = can(lookup(each.value, "public_endpoint")) ? [1] : []
        content {
          is_publicly_accessible = lookup(each.value, "public_endpoint", true)
        }
      }
    }
  }

  dynamic "observability_configuration" {
    for_each = each.value.observability == true ? [1] : []

    content {
      observability_configuration_arn = each.value.observability == true ? aws_apprunner_observability_configuration.app_service[each.key].arn : null
      observability_enabled           = each.value.observability == true ? true : false
    }
  }

  tags = {
    Name = "${each.value.service_name}"
  }
}
