#------------------------------------------
# variable
#------------------------------------------
variable "name" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "https_listener_arn" {
  type = "string"
}

variable "cluster_name" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "db_host" {
  type = "string"
}

variable "db_username" {
  type = "string"
}

variable "db_password" {
  type = "string"
}

variable "db_name" {
  type = "string"
}

variable "app_key" {
  type = "string"
}

#------------------------------------------
# data
#------------------------------------------
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

#------------------------------------------
# local
#------------------------------------------
locals {
  name = "${var.name}-rails"

  # アカウントID
  account_id = data.aws_caller_identity.current.account_id

  # プロビジョニングを実行するリージョン
  region = data.aws_region.current.name
}

#------------------------------------------
# ALBのターゲットグループ作成
#------------------------------------------
resource "aws_lb_target_group" "this" {
  name = local.name

  vpc_id = var.vpc_id

  port        = 80
  target_type = "ip"
  protocol    = "HTTP"

  health_check = {
    port = 80
  }
}

#------------------------------------------
# タスク定義のテンプレート作成
#------------------------------------------
data "template_file" "container_definitions" {
  template = file("./ecs_rails/container_definitions.json")

  vars = {
    tag = "latest"

    account_id = local.account_id
    region     = local.region
    name       = local.name

    db_host     = var.db_host
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password

    app_key = var.app_key
  }
}

#------------------------------------------
# タスク定義作成
#------------------------------------------
resource "aws_ecs_task_definition" "this" {
  family = local.name

  container_definitions = data.template_file.container_definitions.rendered

  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # IAMロールを付与する
  task_role_arn      = aws_iam_role.task_execution.arn
  execution_role_arn = aws_iam_role.task_execution.arn
}

#------------------------------------------
# clowdwatch logsグループ作成
#------------------------------------------
resource "aws_cloudwatch_log_group" "this" {
  name              = "/${var.name}/ecs"
  retention_in_days = "7"
}

#------------------------------------------
# IAMロール作成
#------------------------------------------
resource "aws_iam_role" "task_execution" {
  name = "${var.name}-TaskExecution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#-------------------------------------------------------
# IAMポリシー作成(ECSにclowdwatchへアクセスできるようにするため)
#-------------------------------------------------------
resource "aws_iam_role_policy" "task_execution" {
  role = aws_iam_role.task_execution.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#-------------------------------------------------------
# RoleにIAMポリシーをアタッチする
#-------------------------------------------------------
resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#-------------------------------------------------------
# ALBのリスナールールを作成
#-------------------------------------------------------
resource "aws_lb_listener_rule" "this" {
  # ルールを追加するリスナー
  listener_arn = var.https_listener_arn

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

#-------------------------------------------------------
# セキュリティグループを作成
#-------------------------------------------------------
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

#-------------------------------------------------------
# セキュリティルールを作成(http)
#-------------------------------------------------------
resource "aws_security_group_rule" "this_http" {
  security_group_id = aws_security_group.this.id

  type = "ingress"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

#------------------------------------------
# ECSのサービスを作成
#------------------------------------------
resource "aws_ecs_service" "this" {
  # "aws_lb_listener_rule.this" リソースの作成が完了するのを待ってから当該リソースの作成を開始する。
  depends_on = [aws_lb_listener_rule.this]

  name = local.name
  # データプレーンとしてFargateを使用する
  launch_type = "FARGATE"
  # ECSタスクの起動数を定義
  desired_count = 1
  # 当該ECSサービスを配置するECSクラスターの指定
  cluster = var.cluster_name
  # 起動するECSタスクのタスク定義
  task_definition = aws_ecs_task_definition.this.arn
  # ECSタスクへ設定するネットワークの設定
  network_configuration {
    subnets         = flatten([var.subnet_ids])
    security_groups = [aws_security_group.this.id]
  }
  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "nginx"
    container_port   = "80"
  }
}