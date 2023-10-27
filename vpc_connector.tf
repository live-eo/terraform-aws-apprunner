resource "aws_apprunner_vpc_connector" "app_service" {
  for_each = var.vpc_connector_configuration

  vpc_connector_name = "vpc-connector-${each.key}"
  subnets            = each.value.egress_configuration.subnets
  security_groups    = each.value.egress_configuration.security_groups

  tags = {
    Name = "vpc-connector-${each.key}"
  }
}
