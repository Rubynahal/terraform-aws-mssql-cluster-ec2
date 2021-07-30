locals {
    az1                         = data.aws_subnet.subnet1.availability_zone
    az2                         = data.aws_subnet.subnet2.availability_zone
    admin_secrets               = data.aws_secretsmanager_secret_version.ad_account.secret_string
    sql_secrets                 = data.aws_secretsmanager_secret_version.sql_account.secret_string
    sql_2016_media              = "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLServer2016SP1-FullSlipstream-x64-ENU.iso"
    sql_2017_media              = "https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SQLServer2017-x64-ENU.iso"
    sql_2019_media              = "https://go.microsoft.com/fwlink/?linkid=866664"
    wsfc_node3_private_ip1      = ""
    wsfc_node3_private_ip2      = ""
    wsfc_node3_private_ip3      = ""
    network_interface1          = aws_network_interface.node_1_interface.id
    network_interface2          = aws_network_interface.node_2_interface.id

}

data "aws_subnet" "subnet1" {
  id = var.private_subnet_1
}

data "aws_subnet" "subnet2" {
  id = var.private_subnet_2
}

data "aws_secretsmanager_secret_version" "ad_account" {
  secret_id = data.aws_secretsmanager_secret.admin.id
}

data "aws_secretsmanager_secret" "admin" {
  arn = var.admin_secrets_arn
}

data "aws_secretsmanager_secret_version" "sql_account" {
  secret_id = data.aws_secretsmanager_secret.admin.id
}

data "aws_secretsmanager_secret" "sql" {
  arn = var.sql_secrets_arn
}

data "aws_network_interface" "node1" {
  id          = local.network_interface1
}

data "aws_network_interface" "node2" {
  id           = local.network_interface2

}

#Extract user-data file for domain join and enabling RDS
data "template_file" "ssmautomation" {
  template = "${file("${path.module}/userdata/ssmautomation.ps1")}"
  vars = {
    documentname                    = "${var.prefix}-aws-quickstart.mssql"
    SQLServerVersion                = var.sql_server_version
    SQLLicenseProvided              = var.aws_sql_license
    WSFCNode1NetBIOSName            = var.wsfc_node1_netbios_name
    WSFCNode1PrivateIP1             = tolist(data.aws_network_interface.node1.private_ips)[0]
    WSFCNode1PrivateIP2             = tolist(data.aws_network_interface.node1.private_ips)[1]
    WSFCNode1PrivateIP3             = tolist(data.aws_network_interface.node1.private_ips)[2]
    WSFCNode2NetBIOSName            = var.wsfc_node2_netbios_name
    WSFCNode2PrivateIP1             = tolist(data.aws_network_interface.node2.private_ips)[0]
    WSFCNode2PrivateIP2             = tolist(data.aws_network_interface.node2.private_ips)[1]
    WSFCNode2PrivateIP3             = tolist(data.aws_network_interface.node2.private_ips)[2]
    FSXFileSystem                   = aws_fsx_windows_file_system.fsx.id
    ClusterName                     = var.cluster_name
    AvailabiltyGroupName            = var.availability_group_name
    AvailabiltyGroupListenerName    = var.availability_group_listener_name
    ThirdAZ                         = "witness"
    DomainDNSName                   = var.domain_dns_name
    DomainNetBIOSName               = var.domain_netbios_name
    DomainJoinOU                    = var.domain_join_ou
    DomainDNSServer1                = var.ad_server_1_private_ip 
    DomainDNSServer2                = var.ad_server_2_private_ip 
    ADAdminSecrets                  = var.admin_secrets_arn
    SQLSecrets                      = var.sql_secrets_arn
    SQLAdminGroup                   = var.sql_admin_group_name
    QSS3BucketName                  = var.qs_s3_bucket_name
    QSS3KeyPrefix                   = var.qs_s3_key_prefix
    SQL2016Media                    = local.sql_2016_media
    SQL2017Media                    = local.sql_2017_media
    SQL2019Media                    = local.sql_2019_media
    AWSQuickstartMSSQLRole          = aws_iam_role.ssm_automation_role.arn
    CloudwatchLogGroup              = aws_cloudwatch_log_group.mssql-ssm-automation-cloudwatch-logs.name
  }
}


#Extract user-data file for domain join and enabling RDS
data "template_file" "node1userdata" {
  template = "${file("${path.module}/userdata/node1userdata.ps1")}"
  vars = {
    WSFCNode1PrivateIP1         = tolist(data.aws_network_interface.node1.private_ips)[0]
    WSFCNode1PrivateIP3         = tolist(data.aws_network_interface.node1.private_ips)[2]
    DomainDNSServer1            = var.ad_server_1_private_ip 
    DomainDNSServer2            = var.ad_server_2_private_ip 
  }
}




