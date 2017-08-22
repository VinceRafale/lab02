provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "vpcProd" {
  cidr_block       = "172.23.0.0/16"
  instance_tenancy = "dedicated"

  tags {
    Name = "VPC-Prod"
  }
}

resource "aws_subnet" "vpcProdSubnet1a" {
  vpc_id                  = "${aws_vpc.vpcProd.id}"
  availability_zone       = "eu-west-1a"
  cidr_block              = "172.23.1.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Subnet-Prod-1a"
  }
}

resource "aws_subnet" "vpcProdSubnet1b" {
  vpc_id                  = "${aws_vpc.vpcProd.id}"
  availability_zone       = "eu-west-1b"
  cidr_block              = "172.23.2.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Subnet-Prod-1b"
  }
}

resource "aws_internet_gateway" "vpcProdIgw" {
  vpc_id = "${aws_vpc.vpcProd.id}"

  tags {
    Name = "vpcProdIgw"
  }
}

resource "aws_route_table" "routeTableProdPublic" {
  vpc_id = "${aws_vpc.vpcProd.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpcProdIgw.id}"
  }

  tags {
    Name = "routeTableProdPublic"
  }
}

resource "aws_route_table_association" "routeTableAssocPublic1a" {
  subnet_id      = "${aws_subnet.vpcProdSubnet1a.id}"
  route_table_id = "${aws_route_table.routeTableProdPublic.id}"
}

resource "aws_route_table_association" "routeTableAssocPublic1b" {
  subnet_id      = "${aws_subnet.vpcProdSubnet1b.id}"
  route_table_id = "${aws_route_table.routeTableProdPublic.id}"
}
