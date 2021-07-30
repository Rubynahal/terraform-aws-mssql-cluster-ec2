resource "aws_security_group" "fsx_sg" {
  name        = "${var.prefix}-wsfc-fsx-sg"
  description = "WSFC fsx security group for ${var.prefix}"
  vpc_id      = var.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 5985
    to_port          = 5985
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 49152
    to_port          = 65535
    protocol         = "udp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 49152
    to_port          = 65535
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 88
    to_port          = 88
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 88
    to_port          = 88
    protocol         = "udp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 389
    to_port          = 389
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 389
    to_port          = 389
    protocol         = "udp"
    security_groups      = [var.domain_member_sgids]
  }

  ingress {
    from_port        = 636
    to_port          = 636
    protocol         = "tcp"
    security_groups      = [var.domain_member_sgids]
  }

  tags                    = merge(
    {
    Name                  = "${var.prefix}-wsfc-fsx-sg"
    },
    var.tags
  )
}


resource "aws_fsx_windows_file_system" "fsx" {
  active_directory_id               = var.managed_ad_id
  kms_key_id                        = var.fsx_kms_key
  storage_capacity                  = 300
  storage_type                      = "SSD"
  subnet_ids                        = [var.private_subnet_1, var.private_subnet_2]
  throughput_capacity               = 8
  automatic_backup_retention_days   = 10
  tags                              = var.tags
  daily_automatic_backup_start_time = "01:00"
  weekly_maintenance_start_time     = "4:16:30"
  copy_tags_to_backups              = false
  deployment_type                   = "MULTI_AZ_1"
  preferred_subnet_id               = var.private_subnet_1
  security_group_ids                = [aws_security_group.fsx_sg.id]
  skip_final_backup                 = true
  timeouts {
    create = "60m"
    delete = "2h"
  }
}

