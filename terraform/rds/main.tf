#------------------------------------------
# variable
#------------------------------------------
variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

#------------------------------------------
# local
#------------------------------------------
locals {
  name = "${var.name}-postgresql"
}

#------------------------------------------
# RDSのセキュリティグループを作成
#------------------------------------------
resource "aws_security_group" "this" {
  name        = local.name
  description = local.name
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.name
  }
}



#-----------------------------------------------------------
# RDSのingressセキュリティグループルールの作成(Postgres)
#-----------------------------------------------------------
resource "aws_security_group_rule" "postgres" {
  security_group_id = aws_security_group.this.id

  type = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # 本当はここは許可したIPアドレスのみに制限した方がいい
  cidr_blocks = ["0.0.0.0/0"]
}

#------------------------------------------
# RDSを設置するサブネットグループを作成
#------------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = local.name
  description = local.name
  # var.subnet_idsにはprivate subnetのidsが入っている
  subnet_ids  = flatten([var.subnet_ids])
  tags = {
      Name = var.db_name
  }
}

#------------------------------------------
# RDSを作成
#------------------------------------------
resource "aws_db_instance" "this" {
  identifier           = local.name
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.7"
  instance_class       = "db.t3.micro"
  multi_az             = false # マルチAZは今はとりあえずfalseにしておく
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot = true
}

#------------------------------------------
# output
#------------------------------------------
output "rds_endpoint" {
    value = aws_db_instance.this.address
}








# resource "aws_security_group_rule" "postgresql" {
#   security_group_id = aws_security_group.this.id

#   type = "ingress"

#   from_port   = 5432
#   to_port     = 5432
#   protocol    = "tcp"
#   cidr_blocks = ["10.0.0.0/16"]
# }

# resource "aws_db_subnet_group" "this" {
#   name        = local.name
#   description = local.name
#   subnet_ids  = flatten([var.subnet_ids])
# }




# resource "aws_rds_cluster" "this" {
#   cluster_identifier = local.name
#   engine = "aurora-postgresql"
#   engine_version     = "11.7"
#   engine_mode        = "provisioned" # global,multimaster,parallelquery,serverless, default provisioned

#   database_name   = var.db_name
#   master_username = var.db_username
#   master_password = var.db_password

#   # storage
#   # storage_encrypted = true # declare KMS key ARN if true, default false
#   # kms_key_id               = ""  # set KMS ARN if storage_encrypted is true, default "aws/rds"

#   # network
#   db_subnet_group_name   = aws_db_subnet_group.this.name
#   vpc_security_group_ids = [aws_security_group.this.id]
#   port   = "5432"

#   # backup snapshot
#   backup_retention_period   = 1       # must be between 1 and 35. default 1 (days)
#   copy_tags_to_snapshot     = true    # default false
#   deletion_protection       = false   # default false
#   skip_final_snapshot       = true    # default false
#   final_snapshot_identifier = "app-aurora-postgre" # must be provided if skip_final_snapshot is set to false.

#   # # monitoring
#   # enabled_cloudwatch_logs_exports = ["postgresql"]

#   # # backup window
#   # preferred_backup_window      = "02:00-02:30"

#   # # options
#   # db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_postgre_cpg.name

#   # tags
#   tags = {
#     Service = "app"
#   }
# }



# resource "aws_rds_cluster_instance" "this" {
#   # count              = 2 # count でインスタンスの数を調整できるようにしています。
#   identifier         = local.name
#   cluster_identifier = aws_rds_cluster.this.id
#   instance_class = "db.t3.medium"
#   engine = "aurora-postgresql"
#   engine_version     = "11.7"

#   # netowrok
#   #availability_zone = ""   # eu-west-1a,eu-west-1b,eu-west-1c

#   # monitoring
#   # performance_insights_enabled = false  # default false
#   # monitoring_interval          = 60     # 0, 1, 5, 10, 15, 30, 60 (seconds). default 0 (off)
#   # monitoring_role_arn          = aws_iam_role.monitoring_role.arn 

#   # maintenance window
#   # preferred_maintenance_window = "Mon:03:00-Mon:04:00"

#   # options
#   # db_parameter_group_name    = aws_db_parameter_group.aurora_postgre_pg.name
#   # auto_minor_version_upgrade = false

#   # tags
#   tags = {
#     Service = "app"
#   }

# }

# output "endpoint" {
#   value = aws_rds_cluster.this.endpoint
# }
