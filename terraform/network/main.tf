#------------------------------------------
# variable
#------------------------------------------
variable "name" {
  type = string
}

variable "azs" {
  type    = list
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}


#------------------------------------------
# VPC作成
#------------------------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

#------------------------------------------
# Public Subnet作成(cidrの数だけ(ここでは2つ))
#------------------------------------------
resource "aws_subnet" "publics" {
  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

#------------------------------------------
# インターネットゲートウェイ作成
#------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

#------------------------------------------
# Elastic IP作成
#------------------------------------------
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)

  vpc = true

  tags = {
    Name = "${var.name}-natgw-${count.index}"
  }
}

#------------------------------------------
# NATゲートウェイをcidrの数だけ作成
#------------------------------------------
resource "aws_nat_gateway" "this" {
  count = length(var.public_subnet_cidrs)

  subnet_id     = element(aws_subnet.publics.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)

  tags = {
    Name = "${var.name}-${count.index}"
  }
}

#------------------------------------------
# Public Subnetに関連づけるルートテーブル作成
#------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-public"
  }
}

#-----------------------------------------------------
# Public Subnetからインターネットゲートウェイへのルートを定義
#-----------------------------------------------------
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
}

#-----------------------------------------------------
# ルートテーブル全てをPublic Subnetに関連付け
#-----------------------------------------------------
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#-----------------------------------------------------
# Private Subnetをcidrの数だけ作成
#-----------------------------------------------------
resource "aws_subnet" "privates" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

#-----------------------------------------------------
# Private Subnetに関連づけるルートテーブルをcidrの数だけ作成
#-----------------------------------------------------
resource "aws_route_table" "privates" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

#-----------------------------------------------------
# Private SubnetからNATゲートウェイへのルートを定義
#-----------------------------------------------------
resource "aws_route" "privates" {
  count = length(var.private_subnet_cidrs)

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = element(aws_route_table.privates.*.id, count.index)
  nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
}

#-----------------------------------------------------
# 全てのPrivate Subnetにルートテーブルを関連づける
#-----------------------------------------------------
resource "aws_route_table_association" "privates" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = element(aws_subnet.privates.*.id, count.index)
  route_table_id = element(aws_route_table.privates.*.id, count.index)
}

#-----------------------------------------------------
# output
#-----------------------------------------------------
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [aws_subnet.publics.*.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.privates.*.id]
}
