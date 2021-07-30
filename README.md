# terraform-aws-mssql-cluster-ec2
Terraform module to create mssql cluster on ec2 using ssm automation document. Inspired by the cloudformation template provided by AWS

This module allows to provision and configure a 2 node Microsoft SQL cluster on EC2 joined to a managed AD. It allows you to specify whether you want to use owned licensing (in which case the AMI will be a windows server ami and variable aws_sql_license will be set to "no" and an evaluation version of sql will be downloaded on the server which can later be activated by providing a license) or you want to use AWS provided SQL licensing ( in which case the AMI will be AWS SQL server AMI and aws_sql_license will be set to "yes")

The module creates a SSM automation runbook which will configure the nodes and the cluster. 

The script Domainjoin.ps1 will need to be modified with the OUs in the managed ad environment. You may also modify the initialize-GPT.ps1 script to change the drive specifications. 

The scripts folder should be uploaded to a s3 bucket and the name of the bucket provided in variable qs_s3_bucket_name and if any prefix is used, provide the name in qs_s3_key_prefix.

# Pre-Requisties

1. Create a managed AD AWS delegated administrator and store in a secret manager secret with key value pairs for username and password
 key = username
 value = <the_username_for_admin>
 key = password
 value = <password_for_admin>

 2. Create a domain account for sql services and also specify the SApassword to be used for the sql install and store it in a secret manager secret with key value pairs for username, password and SApassword
 key = username
 value = <the_username_for_sql_service_account>
 key = password
 value = <password_for_sql_service_account>
 key = sapassword
 value = <sa_password_for_sql>

 3. Once the cluster computer account is created in the domain, it should have full permissions on the OU where the computer account for the cluster is located. This is needed for the Availability group computer account and Availability group lister computer account to be created. Otherwise the creation of AG and AG listener will fail. 

 4. Pre-create a domain group that is to be added as a sql sysadmin user on the sql nodes, the name of the group will be the value for variable  mssql_sql_admin_group_name

 5. Make sure to create group policies to allow RDP access to the nodes once they are joined to the domain so you are able to RDP to the boxes. 
 