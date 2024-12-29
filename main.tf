provider "aws" {
  region = "us-east-1"
}

module "vpc_a" {
  source        = "./modules/vpc"
  vpc_cidr      = var.vpc_a_cidr
  public_cidr   = var.subnet_a_public_cidr
  private_cidr  = var.subnet_a_private_cidr
  env_name      = "dev_a"
}

module "vpc_b" {
  source        = "./modules/vpc"
  vpc_cidr      = var.vpc_b_cidr
  public_cidr   = var.subnet_b_public_cidr
  private_cidr  = var.subnet_b_private_cidr
  env_name      = "dev_b"
}


module "vpc_c" {
  source        = "./modules/vpc"
  vpc_cidr      = var.vpc_c_cidr
  public_cidr   = var.subnet_c_public_cidr
  private_cidr  = var.subnet_c_private_cidr
  env_name      = "dev_c"
}

module "tgw" {
  source              = "./modules/tgw"
  env_name            = "dev"
  description         = "Main Transit Gateway for Dev Environment"
  amazon_side_asn     = 64513
  auto_accept_shared_attachments = "enable"
  dns_support         = "enable"
  #vpn_ecmp_support    = "disable"
}

