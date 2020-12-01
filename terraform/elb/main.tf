#------------------------------------------
# variable
#------------------------------------------
variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list
}

variable "domain" {
  type = string
}

variable "acm_id" {
  type = string
}

variable "alb_arn" {
  type = string
}

#------------------------------------------
# ALBのセキュリティグループ作成
#------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name}-alb"
  description = "${var.name} alb"

  vpc_id = var.vpc_id

  # egressは１つしかない為、aws_security_group内で定義してしまっている
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb"
  }
}

#------------------------------------------
# ALBのingressセキュリティグループルールの作成(http)
#------------------------------------------
resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.this.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

#------------------------------------------
# ALBのingressセキュリティグループルールの作成(https)
#------------------------------------------
resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.this.id

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "this" {
  load_balancer_type = "application"
  name               = var.name

  security_groups = [aws_security_group.this.id]
  subnets         = flatten([var.public_subnet_ids])
}

#--------------------------------------------------
# リスナーの作成(とALBとターゲットグループのひも付け)(http)
#--------------------------------------------------
resource "aws_lb_listener" "http" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.this.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


#---------------------------------------------------
# リスナーの作成(とALBとターゲットグループのひも付け)(https)
#---------------------------------------------------
resource "aws_lb_listener" "https" {
  port     = "443"
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # ALBとACM証明書の紐付けはaws_lb_listener のcertificate_arn Argumentに証明書のARNを代入することでできます。
  certificate_arn = var.acm_id
  load_balancer_arn = aws_lb.this.arn

  default_action {
    type             = "forward"
    # ここにECSのサービスをターゲットとして指定する
    # target_group_arn = aws_lb_target_group.this.arn
    target_group_arn = var.alb_arn
  }
}

#---------------------------------------------------
# data (Route53で購入したドメイン(mizutaninaoki.com))
#---------------------------------------------------
data "aws_route53_zone" "this" {
  name         = var.domain
  private_zone = false
}

#---------------------------------------------------
# ALBの情報を元にRoute53にAレコードを設定(ドメインとALBのDNSを紐付け)
#---------------------------------------------------
resource "aws_route53_record" "this" {
  type = "A"

  name    = var.domain
  zone_id = data.aws_route53_zone.this.id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

#---------------------------------------------------
# output
#---------------------------------------------------
output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}
