
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main"{
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

##-------------------------------------------------------------------------------------------##
## Public
##-------------------------------------------------------------------------------------------##

resource "aws_subnet" "public-subnets" {
  count = length(var.public_subnet_ciders)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_ciders, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-pub-sub-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-public-subnet-rt"
  }
}

resource "aws_route_table_association" "public_routes" {
  count = length(aws_subnet.public-subnets[*].id)
  subnet_id      = element(aws_subnet.public-subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

##-------------------------------------------------------------------------------------------##
## DB
##-------------------------------------------------------------------------------------------##

resource "aws_subnet" "db-subnets" {
  count = length(var.db_subnet_ciders)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.db_subnet_ciders, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = "${var.env}-db-sub-${count.index + 1}"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "${var.env}-db-subnet-rt"
  }
}

resource "aws_route_table_association" "db_routes" {
  count = length(aws_subnet.db-subnets[*].id)
  subnet_id      = element(aws_subnet.db-subnets[*].id, count.index)
  route_table_id = aws_route_table.db_route_table.id
}


##-------------------------------------------------------------------------------------------##
## Private
##-------------------------------------------------------------------------------------------##

resource "aws_subnet" "private-subnets" {
  count = length(var.private_subnet_ciders)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_ciders, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = "${var.env}-private-sub-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = 2
  domain = "vpc"
  
  depends_on = [aws_internet_gateway.main] 

  tags = {
    Name = "${var.env}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id

  subnet_id = aws_subnet.public-subnets[count.index].id

  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}

resource "aws_route_table" "private-route_table" {
  count  = 2
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${var.env}-private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_routes" {
  count          = 2
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-route_table[count.index].id
}
