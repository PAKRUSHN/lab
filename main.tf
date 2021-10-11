# --- compute/main.tf  --- #


data "aws_availability_zones" "availability" {
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.availability.names
  result_count = var.max_subnets
}

resource "aws_vpc" "pakrushn_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "pakrushn_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_subnet" "pakrushn_public_subnets" {
  count                   = var.public_sn_count
  vpc_od                  = aws_vpc.pakrushn_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]
  
  
  tags = {
    Name = "pakrushn_public_${count.index + 1}"
  }
}


resource "aws_route_table_association" "pakrushn_public_assoc" {
  count          = var.public_sn_count 
  subnet_id      = aws_subnet.pakrushn_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.pakrushn_public_rt.id
}

resource "aws_internet_gateway" "pakrushn_internet_gateway" {
  vpc_id = aws_vpc.pakrushn_vpc.id
  
  tags = {
    Name = " pakrushn_igw"
  }
}

resouces "aws_route_table" "pakrush_public_rt" {
  vpc_id = aws_vpc.pakrushn_vpc.id
  tags = {
    Name = "pakrushn_public"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.pakrushn_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pakrushn_internet_gateway.id
  
}  

resource "aws_security_group" "pakrushn_sg" {
  for_each  = var.security_groups
  name      = each.value.name
  descipton = each.value.descripton
  vpc_id    = aws_vpc_pakrushn_vpc.id
}  
  
  
  dynamic "ingress" {
    for_each = each.value.ingress
      content {
        
        from_part   = ingress.value.from
        to_part     = ingres.value.to
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
  }
    
  egress { 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
  tags = {
    Name = "pakrushn-sg"
  }
    
    
    
  

  
  






