resource "aws_apprunner_custom_domain_association" "custom_domain_config" {
  #for_each = var.services
  for_each = { for service_name, service in var.services : service_name => service if service.custom_domain != null }

  domain_name          = each.value.custom_domain.domain_name
  service_arn          = aws_apprunner_service.app_service[each.key].arn
  enable_www_subdomain = each.value.custom_domain.enable_www_subdomain
}
