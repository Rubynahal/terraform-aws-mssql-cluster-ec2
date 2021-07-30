######## MS SQL CLUSTER ##########
locals {
  mssql_cluster_name                     = "IR-QA-SQL-C001"
  mssql_availability_group_name          = "IR-QA-AG-001"
  mssql_availability_group_listener_name = "IR-QA-AG-L001"
  mssql_ami_for_node                     = "ami-0fa60543f60171fe3"
  mssql_domain_dns_name                  = "nonprod.example.internal"
  mssql_domain_netbios_name              = "NONPROD"
  mssql_domain_join_ou                   = "NONPROD"
  mssql_admin_secrets_arn                = "arn:aws:secretsmanager:us-east-1:945151621816:secret:quickstart/mssql/adminsecret-N9XLmv"
  mssql_sql_secrets_arn                  = "arn:aws:secretsmanager:us-east-1:945151621816:secret:quickstart/mssql/sqlsecret-VgqQ89"
  mssql_sql_admin_group_name             = "Example SQL Server administrators"
  mssql_mssql_key_name                   = local.key_name
  mssql_ebs_kms_key                      = module.ebs-kms.key_arn
  mssql_private_subnet_1                 = tolist(data.aws_subnet_ids.data_subnets.ids)[0]
  mssql_private_subnet_2                 = tolist(data.aws_subnet_ids.data_subnets.ids)[1]
  mssql_private_subnet_3                 = tolist(data.aws_subnet_ids.data_subnets.ids)[2]
  mssql_qs_s3_bucket_name                = "example-mssql-quickstart-bucket"
  mssql_qs_s3_key_prefix                 = local.prefix
  mssql_volume_1_iops                    = 3000
  mssql_volume_1_size                    = 250
  mssql_volume_2_iops                    = 3000
  mssql_volume_2_size                    = 250
  mssql_volume_3_iops                    = 3000
  mssql_volume_3_size                    = 250
  mssql_volume_4_iops                    = 3000
  mssql_volume_4_size                    = 250
  mssql_volume_5_iops                    = 3000
  mssql_volume_5_size                    = 250
  mssql_volume_6_iops                    = 3000
  mssql_volume_6_size                    = 250
  mssql_wsfc_node1_instance_type         = "r5a.2xlarge"
  mssql_wsfc_node1_netbios_name          = "IR-QA-SQL-N001"
  mssql_wsfc_node2_instance_type         = "r5a.2xlarge"
  mssql_wsfc_node2_netbios_name          = "IR-QA-SQL-N002"
  mssql_aws_sql_license                  = "no"
}

module "mssql-cluster" {
  source                            = "../modules/mssql-cluster"
  prefix                            = local.prefix
  managed_ad_id                     = local.managed_ad_id
  ad_server_1_private_ip            = local.managed_ad_ip1
  ad_server_2_private_ip            = local.managed_ad_ip2
  cluster_name                      = local.mssql_cluster_name
  availability_group_name           = local.mssql_availability_group_name
  availability_group_listener_name  = local.mssql_availability_group_listener_name
  ami_for_node                      = local.mssql_ami_for_node 
  domain_dns_name                   = local.mssql_domain_dns_name
  domain_member_sgids               = module.domain-sg.this_security_group_id
  domain_netbios_name               = local.mssql_domain_netbios_name
  domain_join_ou                    = local.mssql_domain_join_ou
  admin_secrets_arn                 = local.mssql_admin_secrets_arn
  sql_secrets_arn                   = local.mssql_sql_secrets_arn
  sql_admin_group_name              = local.mssql_sql_admin_group_name
  key_name                          = local.key_name
  ebs_kms_key                       = module.fsx-kms.key_arn
  private_subnet_1                  = local.mssql_private_subnet_1 
  private_subnet_2                  = local.mssql_private_subnet_2 
  private_subnet_3                  = local.mssql_private_subnet_3 
  qs_s3_bucket_name                 = local.mssql_qs_s3_bucket_name
  qs_s3_key_prefix                  = local.mssql_qs_s3_key_prefix
  volume_1_iops                     = local.mssql_volume_1_iops
  volume_1_size                     = local.mssql_volume_1_size  
  volume_2_iops                     = local.mssql_volume_2_iops
  volume_2_size                     = local.mssql_volume_2_size
  volume_3_iops                     = local.mssql_volume_3_iops 
  volume_3_size                     = local.mssql_volume_3_size
  volume_4_iops                     = local.mssql_volume_4_iops
  volume_4_size                     = local.mssql_volume_4_size
  volume_5_iops                     = local.mssql_volume_5_iops
  volume_5_size                     = local.mssql_volume_5_size
  volume_6_iops                     = local.mssql_volume_6_iops
  volume_6_size                     = local.mssql_volume_6_size
  vpc_id                            = module.vpc.vpc_id
  wsfc_node1_instance_type          = local.mssql_wsfc_node1_instance_type
  wsfc_node1_netbios_name           = local.mssql_wsfc_node1_netbios_name
  wsfc_node2_instance_type          = local.mssql_wsfc_node2_instance_type
  wsfc_node2_netbios_name           = local.mssql_wsfc_node2_netbios_name
  aws_sql_license                   = local.mssql_aws_sql_license
  tags                              = local.mssql_tags
  cloudwatch_kms_key_id             = module.cloudwatch-kms.key_arn
  fsx_kms_key                       = module.fsx-kms.key_arn
}


