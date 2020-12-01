#------------------------------------------
# variable
#------------------------------------------
variable "access_key" {}
variable "secret_key" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "region" { default = "ap-northeast-1" }
variable "public_key_path" {}
variable "alb_arn" {}

variable "name" {
  type    = string
}

variable "azs" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "domain" {
  type = string
}

#------------------------------------------
# provider
#------------------------------------------
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

#------------------------------------------
# Network(VPC、サブネット、セキュリティグループ等)
#------------------------------------------
module "network" {
  source = "./network"
  name = var.name
  azs = var.azs
}

#------------------------------------------
# ACM
#------------------------------------------
module "acm" {
  source = "./acm"
  name = var.name
  domain = var.domain
}

#------------------------------------------
# ロードバランサー
#------------------------------------------
module "elb" {
  source = "./elb"
  name = var.name

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  domain            = var.domain
  acm_id            = module.acm.acm_id

  # ECSのARN
  alb_arn = var.alb_arn
}

#------------------------------------------
# RDS
#------------------------------------------
module "rds" {
  source = "./rds"
  name = var.name

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids

  db_name   = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

#------------------------------------------
# EC2(RDSへsshできるよう踏み台サーバーとしての役割)
#------------------------------------------
module "ec2" {
  source = "./ec2"

  name              = var.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  public_key_path   = var.public_key_path
}

#------------------------------------------
# nginx
#------------------------------------------
# module "nginx" {
#   source = "./nginx"

#   name = var.name

#   cluster_name       = module.ecs_cluster.cluster_name
#   vpc_id             = module.network.vpc_id
#   subnet_ids         = module.network.private_subnet_ids
#   https_listener_arn = module.elb.https_listener_arn
# }

#------------------------------------------
# ECS
#------------------------------------------
# module "ecs_cluster" {
#   source = "./ecs_cluster"

#   name = var.name
# }

# module "ecs_rails" {
#   source = "./ecs_rails"

#   name = var.name

#   cluster_name       = module.ecs_cluster.cluster_name
#   vpc_id             = module.network.vpc_id
#   subnet_ids         = module.network.private_subnet_ids
#   https_listener_arn = module.elb.https_listener_arn

#   db_host = module.rds.endpoint

#   db_name = var.db_name
#   db_username = var.db_username
#   db_password = var.db_password

#   app_key = var.app_key
# }