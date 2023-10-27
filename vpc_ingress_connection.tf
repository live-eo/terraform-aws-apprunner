resource "aws_apprunner_vpc_ingress_connection" "app_service" {
  for_each    = { for service_name, service in var.services : service_name => service if service.public_endpoint == false }
  name        = each.value.service_name
  service_arn = aws_apprunner_service.app_service[each.key].arn

  ingress_vpc_configuration {
    vpc_id          = var.vpc.id
    vpc_endpoint_id = var.interface_endpoint.id
  }

  tags = {
    Name = "${each.value.service_name}"
  }
}
