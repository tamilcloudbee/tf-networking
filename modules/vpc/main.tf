resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc_${var.env_name}_us-east-1"
  }
}

# Public Subnet (Now using the main route table)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_${var.env_name}_us-east-1"
  }
}

# Private Subnet (Using a custom route table, but no Internet Gateway route)
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_subnet_${var.env_name}_us-east-1"
  }
}

# Internet Gateway (For Public Subnet Access)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "vpc_${var.env_name}_igw"
  }
}

# Add a route to the main route table for public subnet internet access
resource "aws_route" "public_internet_route" {
  route_table_id         = data.aws_route_table.default_main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id            = aws_internet_gateway.igw.id

  depends_on = [aws_internet_gateway.igw]
}

# Data Source to fetch the default main route table ID
data "aws_route_table" "default_main_rt" {
  vpc_id = aws_vpc.vpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Tag the default main route table with the custom name format
resource "null_resource" "tag_main_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws ec2 create-tags --resources ${data.aws_route_table.default_main_rt.id} --tags Key=Name,Value=vpc_${var.env_name}_main_public_rt
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Create a custom route table for the private subnet (No Internet Gateway route)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc_${var.env_name}_main_private_rt"
  }
}

# Associate the private subnet with the new private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# (Optional) Add a NAT Gateway or other routes for the private subnet if needed
# If you need the private subnet to have internet access via a NAT Gateway, you could add a route like this:

# resource "aws_route" "private_to_nat" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }
