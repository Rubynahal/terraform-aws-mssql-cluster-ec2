# terraform-aws-mssql-cluster-ec2
Terraform module to create mssql cluster on ec2 using ssm automation document. Inspired by the cloudformation template provided by AWS

This module allows to provision and configure a 2 node Microsoft SQL cluster on EC2 joined to a managed AD. It allows you to specify whether you want to use owned licensing (in which case the AMI will be a windows server ami and variable aws_sql_license will be set to "no" and an evaluation version of sql will be downloaded on the server which can later be activated by providing a license) or you want to use AWS provided SQL licensing ( in which case the AMI will be AWS SQL server AMI and aws_sql_license will be set to "yes")

The module creates a SSM automation runbook which will configure the nodes and the cluster. 

The script Domainjoin.ps1 will need to be modified with the OUs in the managed ad environment. You may also modify the initialize-GPT.ps1 script to change the drive specifications. 

The scripts folder should be uploaded to a s3 bucket and the name of the bucket provided in variable qs_s3_bucket_name and if any prefix is used, provide the name in qs_s3_key_prefix.

