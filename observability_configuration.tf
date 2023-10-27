resource "aws_apprunner_observability_configuration" "app_service" {
  for_each = { for service_name, service in var.services : service_name => service if service.observability == true }

  observability_configuration_name = each.value.service_name
  trace_configuration {
    vendor = "AWSXRAY"
  }

  tags = {
    Name = "${each.value.service_name}"
  }
}
