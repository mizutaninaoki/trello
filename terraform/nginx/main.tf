#------------------------------------------
# variable
#------------------------------------------
variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "https_listener_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list
}

#------------------------------------------
# local
#------------------------------------------
locals {
  name = "${var.name}-nginx"
}


#------------------------------------------
# ALBのターゲットグループを作成
#------------------------------------------
resource "aws_lb_target_group" "this" {
  name = local.name
  # ターゲットグループを作成するVPC
  vpc_id = var.vpc_id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"

  # コンテナへの死活監視設定
  health_check {
    port = 80
  }
}

#------------------------------------------
# data ECSのタスク定義
#------------------------------------------
data "template_file" "container_definitions" {
  template = file("./container_definitions.json")
}

#------------------------------------------
# ECSのタスク定義を作成
#------------------------------------------
resource "aws_ecs_task_definition" "this" {
  family = local.name

  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # タスク定義を記したjsonをcontainer_definitionsに代入する
  container_definitions = data.template_file.container_definitions.rendered
}

#------------------------------------------
# ALBのリスナールールを作成
#------------------------------------------
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

#------------------------------------------
# セキュリティグループを作成
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

#------------------------------------------
# セキュリティルールを作成(ingress)
#------------------------------------------
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
