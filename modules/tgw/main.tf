# main.tf in modules/tgw

resource "aws_ec2_transit_gateway" "tgw" {
  description = var.description != "" ? var.description : "Transit Gateway for ${var.env_name}"
  amazon_side_asn = var.amazon_side_asn
  auto_accept_shared_attachments = var.auto_accept_shared_attachments
  dns_support = var.dns_support
  vpn_ecmp_support = var.vpn_ecmp_support
  tags = {
    Name = "tgw_${var.env_name}"
  }
}
