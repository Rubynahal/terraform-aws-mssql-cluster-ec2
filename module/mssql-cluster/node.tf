# variable "subnet_id" {}

# data "aws_subnet" "data" {
#   id = "subnet-0954d19d0f0cc6496"
# }

##Placeholder sg
resource "aws_security_group" "wsfc_sg" {
  name                    = "${var.prefix}-wsfc-cluster-sg"
  description             = "Microsoft sql security group for ${var.prefix} environment"
  vpc_id                  = var.vpc_id #data.aws_subnet.data.vpc_id

  tags                    = merge(
    {
    Name                  = "${var.prefix}-wsfc-cluster-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "icmp1" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.wsfc_sg.id
  source_security_group_id = var.domain_member_sgids
}

resource "aws_security_group_rule" "rdpfrombastion" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  security_group_id = aws_security_group.wsfc_sg.id
  source_security_group_id = var.domain_member_sgids
}

resource "aws_security_group_rule" "tcp135" {
  type              = "ingress"
  from_port         = 135
  to_port           = 135
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcp137" {
  type              = "ingress"
  from_port         = 137
  to_port           = 137
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcp445" {
  type              = "ingress"
  from_port         = 445
  to_port           = 445
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcp1433" {
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcp3343" {
  type              = "ingress"
  from_port         = 3343
  to_port           = 3343
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcp5022" {
  type              = "ingress"
  from_port         = 5022
  to_port           = 5022
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcp5985" {
  type              = "ingress"
  from_port         = 5985
  to_port           = 5985
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "udp137" {
  type              = "ingress"
  from_port         = 137
  to_port           = 137
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "udp3343" {
  type              = "ingress"
  from_port         = 3343
  to_port           = 3343
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}


resource "aws_security_group_rule" "udp1434" {
  type              = "ingress"
  from_port         = 1434
  to_port           = 1434
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "udphighports" {
  type              = "ingress"
  from_port         = 49152
  to_port           = 65535
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}

resource "aws_security_group_rule" "tcphighports" {
  type              = "ingress"
  from_port         = 49152
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.wsfc_sg.id
}


resource "aws_security_group" "wsfc_client_sg" {
  name        = "${var.prefix}-wsfc-client-sg"
  description = "WSFC client group for ${var.prefix}"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SQL Client access ports"
    from_port        = 1443
    to_port          = 1443
    protocol         = "tcp"
    self             = true
  }
  tags                    = merge(
    {
    Name                  = "${var.prefix}-wsfc-client-sg"
    },
    var.tags
  )
}


resource "aws_network_interface" "node_1_interface" {
  subnet_id               = var.private_subnet_1 #data.aws_subnet.data.subnet_id
  private_ips_count       = 2
  security_groups         = [var.domain_member_sgids,aws_security_group.wsfc_sg.id,aws_security_group.wsfc_client_sg.id]
#   private_ips = ["10.10.130.180"]
  tags                    = merge(
    {
    Name                  = "primary_network_interface_node1_NI1"
    },
    var.tags
  )
}

resource "aws_network_interface" "node_2_interface" {
  subnet_id               = var.private_subnet_2 #data.aws_subnet.data.subnet_id
#   private_ips = ["10.10.13.105"]
  security_groups         = [var.domain_member_sgids,aws_security_group.wsfc_sg.id,aws_security_group.wsfc_client_sg.id]
  private_ips_count       = 2
  tags                    = merge(
    {
    Name                  = "primary_network_interface_node2_NI1"
    },
    var.tags
  )
}

resource "aws_instance" "node_1" {
  ami                     = var.ami_for_node #"ami-03397bf08598d7ae4" ##us-east-1 2019 sql server 2019 enterprise
  instance_type           = var.wsfc_node1_instance_type
  key_name                = var.key_name
  user_data               = data.template_file.node1userdata.rendered
  disable_api_termination = true
  network_interface {
    network_interface_id  = aws_network_interface.node_1_interface.id
    device_index          = 0
  }
  
  #subnet_id               = var.private_subnet_1 #data.aws_subnet.data.subnet_id
  credit_specification {
    cpu_credits           = "unlimited"
  }
  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = false
    encrypted             = true
    kms_key_id            = var.ebs_kms_key
    tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume0"
    },
    var.tags
  )
  }
  ebs_optimized = true
  iam_instance_profile    = aws_iam_instance_profile.wsfc_role.name
  tags                    = merge(
    {
     Name                 = var.wsfc_node1_netbios_name
    },
    var.tags
  )

  lifecycle {
    ignore_changes = [user_data]
  }  
}


resource "aws_instance" "node_2" {
  ami                     = var.ami_for_node #"ami-03397bf08598d7ae4" ##us-east-1 2019 sql server 2019 enterprise
  instance_type           = var.wsfc_node2_instance_type
  key_name                = var.key_name
  user_data               = data.template_file.ssmautomation.rendered
  disable_api_termination = true
  network_interface {
    network_interface_id  = aws_network_interface.node_2_interface.id
    device_index          = 0
  }
  
  #subnet_id               = var.private_subnet_2 #data.aws_subnet.data.subnet_id
  credit_specification {
    cpu_credits           = "unlimited"
  }
  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = false
    encrypted             = true
    kms_key_id            = var.ebs_kms_key
    tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume0"
    },
    var.tags
  )
  }
  ebs_optimized           = true
  iam_instance_profile    = aws_iam_instance_profile.wsfc_role.name
  tags                    = merge(
    {
     Name                 = var.wsfc_node2_netbios_name
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [user_data]
  }  
  depends_on              = [aws_instance.node_1, aws_fsx_windows_file_system.fsx, aws_ssm_document.aws_quickstart_mssql]
}

resource "aws_ebs_volume" "node1_volume1" {
  availability_zone       = local.az1
  size                    = var.volume_1_size
  type                    = var.volume_1_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_1_type != "gp2" ? var.volume_1_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume1"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node1_volume2" {
  availability_zone       = local.az1
  size                    = var.volume_2_size
  type                    = var.volume_2_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_2_type != "gp2" ? var.volume_2_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume2"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node1_volume3" {
  availability_zone       = local.az1
  size                    = var.volume_3_size
  type                    = var.volume_3_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_3_type != "gp2" ? var.volume_3_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume3"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node1_volume4" {
  availability_zone       = local.az1
  size                    = var.volume_4_size
  type                    = var.volume_4_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_4_type != "gp2" ? var.volume_4_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume4"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node1_volume5" {
  availability_zone       = local.az1
  size                    = var.volume_5_size
  type                    = var.volume_5_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_5_type != "gp2" ? var.volume_5_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume5"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node1_volume6" {
  availability_zone       = local.az1
  size                    = var.volume_6_size
  type                    = var.volume_6_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_6_type != "gp2" ? var.volume_6_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node1_netbios_name}_volume6"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node2_volume1" {
  availability_zone       = local.az2
  size                    = var.volume_1_size
  type                    = var.volume_1_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_1_type != "gp2" ? var.volume_1_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume1"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node2_volume2" {
  availability_zone       = local.az2
  size                    = var.volume_2_size
  type                    = var.volume_2_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_2_type != "gp2" ? var.volume_2_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume2"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node2_volume3" {
  availability_zone       = local.az2
  size                    = var.volume_3_size
  type                    = var.volume_3_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_3_type != "gp2" ? var.volume_3_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume3"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node2_volume4" {
  availability_zone       = local.az2
  size                    = var.volume_4_size
  type                    = var.volume_4_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_4_type != "gp2" ? var.volume_4_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume4"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node2_volume5" {
  availability_zone       = local.az2
  size                    = var.volume_5_size
  type                    = var.volume_5_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_5_type != "gp2" ? var.volume_5_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume5"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "node2_volume6" {
  availability_zone       = local.az2
  size                    = var.volume_6_size
  type                    = var.volume_6_type
  encrypted               = true
  kms_key_id              = var.ebs_kms_key
  iops                    = var.volume_6_type != "gp2" ? var.volume_6_iops : ""
  tags                    = merge(
    {
     Name                 = "${var.wsfc_node2_netbios_name}_volume6"
    },
    var.tags
  )
}

resource "aws_volume_attachment" "node1_ebs_att_volume1" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.node1_volume1.id
  instance_id = aws_instance.node_1.id
}
resource "aws_volume_attachment" "node1_ebs_att_volume2" {
  device_name = "/dev/xvdc"
  volume_id   = aws_ebs_volume.node1_volume2.id
  instance_id = aws_instance.node_1.id
  depends_on = [
    aws_volume_attachment.node1_ebs_att_volume1,
  ]
}
resource "aws_volume_attachment" "node1_ebs_att_volume3" {
  device_name = "/dev/xvdd"
  volume_id   = aws_ebs_volume.node1_volume3.id
  instance_id = aws_instance.node_1.id
  depends_on = [
    aws_volume_attachment.node1_ebs_att_volume2,
  ]
}
resource "aws_volume_attachment" "node1_ebs_att_volume4" {
  device_name = "/dev/xvde"
  volume_id   = aws_ebs_volume.node1_volume4.id
  instance_id = aws_instance.node_1.id
  depends_on = [
    aws_volume_attachment.node1_ebs_att_volume3,
  ]
}
resource "aws_volume_attachment" "node1_ebs_att_volume5" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.node1_volume5.id
  instance_id = aws_instance.node_1.id
  depends_on = [
    aws_volume_attachment.node1_ebs_att_volume4,
  ]
}

resource "aws_volume_attachment" "node1_ebs_att_volume6" {
  device_name = "/dev/xvdg"
  volume_id   = aws_ebs_volume.node1_volume6.id
  instance_id = aws_instance.node_1.id
  depends_on = [
    aws_volume_attachment.node1_ebs_att_volume5,
  ]
}
resource "aws_volume_attachment" "node2_ebs_att_volume1" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.node2_volume1.id
  instance_id = aws_instance.node_2.id
}
resource "aws_volume_attachment" "node2_ebs_att_volume2" {
  device_name = "/dev/xvdc"
  volume_id   = aws_ebs_volume.node2_volume2.id
  instance_id = aws_instance.node_2.id
  depends_on = [
    aws_volume_attachment.node2_ebs_att_volume1,
  ]
}
resource "aws_volume_attachment" "node2_ebs_att_volume3" {
  device_name = "/dev/xvdd"
  volume_id   = aws_ebs_volume.node2_volume3.id
  instance_id = aws_instance.node_2.id
  depends_on = [
    aws_volume_attachment.node2_ebs_att_volume2,
  ]
}
resource "aws_volume_attachment" "node2_ebs_att_volume4" {
  device_name = "/dev/xvde"
  volume_id   = aws_ebs_volume.node2_volume4.id
  instance_id = aws_instance.node_2.id
  depends_on = [
    aws_volume_attachment.node2_ebs_att_volume3,
  ]
}
resource "aws_volume_attachment" "node2_ebs_att_volume5" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.node2_volume5.id
  instance_id = aws_instance.node_2.id
  depends_on = [
    aws_volume_attachment.node2_ebs_att_volume4,
  ]
}

resource "aws_volume_attachment" "node2_ebs_att_volume6" {
  device_name = "/dev/xvdg"
  volume_id   = aws_ebs_volume.node2_volume6.id
  instance_id = aws_instance.node_2.id
  depends_on = [
    aws_volume_attachment.node2_ebs_att_volume5,
  ]
}


