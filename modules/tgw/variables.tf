# variables.tf in modules/tgw

variable "env_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "description" {
  description = "The description of the Transit Gateway"
  type        = string
  # Remove the default value here
  default     = ""
}

variable "amazon_side_asn" {
  description = "The Amazon ASN for the Transit Gateway"
  type        = number
  default     = 64512
}



variable "dns_support" {
  description = "Whether the Transit Gateway supports DNS"
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether the Transit Gateway supports VPN ECMP"
  type        = string
  default     = "disable"
}


# variables.tf in modules/tgw

variable "auto_accept_shared_attachments" {
  description = "Whether the Transit Gateway should automatically accept shared attachments"
  type        = string
  default     = "enable"  # You can use "enable" or "disable" by default
}
