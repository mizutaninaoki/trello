#------------------------------------------
# variable
#------------------------------------------
variable "name" {
  type = string
}

variable "domain" {
  type = string
}

#------------------------------------------
# data(terraformで定義していないAWSのリソース)
#------------------------------------------
data "aws_route53_zone" "this" {
  name         = var.domain
  private_zone = false
}

#------------------------------------------
# ACM証明書
#------------------------------------------
resource "aws_acm_certificate" "this" {
  domain_name = var.domain

  # DNS検証を指定すると、Attributesでdomain_validation_optionsが返ってきます。これを次のリソースで活用します。
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true # trueにするとACM証明書の期限が切れる前に新しい証明書を自動的に作成してくれる
  }
}

#------------------------------------------
# ホストゾーン内にレコードを作成
#------------------------------------------
resource "aws_route53_record" "this" {
  depends_on = [aws_acm_certificate.this]

  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.id
}

#------------------------------------------
# 作ったACM証明書とCNAMEレコードの連携
#------------------------------------------
resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}

#------------------------------------------
# output
#------------------------------------------
output "acm_id" {
  value = aws_acm_certificate.this.id
}
