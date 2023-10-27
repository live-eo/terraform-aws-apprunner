resource "aws_apprunner_auto_scaling_configuration_version" "common_autoscaling_config" {
  for_each = var.auto_scaling_configurations

  auto_scaling_configuration_name = each.value.name
  max_concurrency                 = each.value.max_concurrency
  max_size                        = each.value.max_size
  min_size                        = each.value.min_size

  tags = each.value.tags
}
