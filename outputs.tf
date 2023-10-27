output "service_urls" {
  description = "The URLs of the deployed services."
  value       = { for key, svc in aws_apprunner_service.app_service : key => svc.service_url }
}

output "service_arns" {
  description = "The ARNs of the deployed services."
  value       = { for key, svc in aws_apprunner_service.app_service : key => svc.arn }
}

output "app_runner_config" {
  description = "Map of app runner config for monitoring system."
  value       = { for key, svc in aws_apprunner_service.app_service : svc.service_name => svc.service_id }
}

output "vpc_connector_arn" {
  description = "The ARN for the newly created VPC connector for each service."
  value       = { for key, svc in aws_apprunner_vpc_connector.app_service : key => svc.arn }
}

output "custom_domain_ids" {
  description = "The IDs for the custom domain associations. This includes the domain_name and service_arn separated by a comma."
  value       = { for key, domain in aws_apprunner_custom_domain_association.custom_domain_config : key => domain.id }
}

output "custom_domain_certificate_validation_records" {
  description = "The certificate validation records for the custom domain associations."
  value       = { for key, domain in aws_apprunner_custom_domain_association.custom_domain_config : key => domain.certificate_validation_records }
}

output "custom_domain_dns_targets" {
  description = "The DNS targets for the custom domain associations."
  value       = { for key, domain in aws_apprunner_custom_domain_association.custom_domain_config : key => domain.dns_target }
}
