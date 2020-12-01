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

variable "public_key_path" {
  type = string
}

#------------------------------------------
# EC2(踏み台サーバー)のセキュリティグループ作成
#------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name}-ec2"
  description = "${var.name} ec2"

  vpc_id = var.vpc_id

  # egressは１つしかない為、aws_security_group内で定義してしまっている
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ec2"
  }
}

#-----------------------------------------------------------
# EC2(踏み台サーバー)のingressセキュリティグループルールの作成(ssh)
#-----------------------------------------------------------
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.this.id

  type = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # 本当はここは許可したIPアドレスのみに制限した方がいい
  cidr_blocks = ["0.0.0.0/0"]
}

#------------------------------------------
# EC2に使用する公開鍵を設定
#------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = file(var.public_key_path)
}

#------------------------------------------
# Elastic IP作成
#------------------------------------------
resource "aws_eip" "fumidai-ec2" {
  vpc = true

  tags = {
    Name = "${var.name}-fumidai-ec2"
  }
}

#------------------------------------------
# EC2インスタンス作成
#------------------------------------------
resource "aws_instance" "this" {
    ami                         = "ami-034968955444c1fd9"  # 東京リージョンにある Amazon Linux 2 AMI の ID を指定
    instance_type               = "t2.micro"
    key_name                    = aws_key_pair.this.id  # EC2に入るために上で作成した公開鍵の名前(id)
    vpc_security_group_ids      = [aws_security_group.this.id]
    # 踏み台サーバーとしてEC2を１つだけ配置する(public_subnet_idsという配列から最初のpublic_subnet_idを取得)
    subnet_id                   = var.public_subnet_ids[0][0]
    associate_public_ip_address = "true"

    # OSがインストールされるボリューム
    root_block_device {
        volume_type = "gp2"
        volume_size = "20"
    }

    # root_block_device以外のボリューム(device_name (/dev/sdbとか)を変えて、複数作成可能)
    # ログなどが保管される
    ebs_block_device {
        device_name = "/dev/sdf"
        volume_type = "gp2"
        volume_size = "30" # ギガ数(30GBまでがEC2の無料利用枠対象のサイズ)
    }
    tags = {
        Name = "fumidai_ec2"
    }
}

#------------------------------------------
# Elastic IPをEC2(踏み台サーバー)にアタッチ
#------------------------------------------
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.fumidai-ec2.id
}



#---------------------------------------------------
# output
#---------------------------------------------------
output "id" {
  description = "作成したEC2のid"
  value       = aws_instance.this.*.id
}

output "arn" {
  description = "作成したEC2のARN"
  value       = aws_instance.this.*.arn
}