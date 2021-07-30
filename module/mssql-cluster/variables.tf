variable "prefix" {
    description = "Prefix used to name resources"
    default     = ""
}

variable "managed_ad" {
    description = "Select the type of AD DS deployment to use: AWS Directory Servicefor Microsoft AD or managing your own Amazon EC2 AD instances."
    default     = "yes"
}

variable "managed_ad_id" {
    description = "The ID for an existing Microsoft Active Directory instance that the file system should join when it's created. "
    default     = null
}

variable "ad_server_1_private_ip" {
    description = "The IP address of the first Domain Controller. For AWS Managed AD, use the first DNS address."
    type        = string
    default     = ""
}

variable "ad_server_2_private_ip" {
    description = "The IP address of the first Domain Controller. For AWS Managed AD, use the Second DNS address."
    type        = string
    default     = ""
}

variable "cluster_name" {
    default =  "AGXX-Cluster"
    description =  "NetBIOS name of the cluster (up to 15 characters)."
    type        = string
}

variable "availability_group_name" {
    description   = "NetBIOS name of the availability group (up to 15 characters)."
    default       = "AGXX"
    type          = string
}

variable "availability_group_listener_name" {
    description   = "NetBIOS name of the availability group (up to 15 characters)."
    default       = "AGXXL"
    type          = string
}

variable "ami_for_node"  {
    description   = "If AMI that using default isn't work correctly please fill in your AMI ID for NODE(ami-0535521257567a0c4) by default will be used Windows_Server-2019-English-Full-SQL_2017_Enterprise."
    type          = string
    default       = null

}

variable "ami_for_fileserver"  {
    description   = "If AMI that using default isn't work correctly please fill in your AMI ID for NODE(ami-0535521257567a0c4) by default will be used Windows_Server-2019-English-Full-SQL_2017_Enterprise."
    default       = ""
    type          = string 

}

variable "domain_dns_name"{
    description   = "Fully qualified domain name (FQDN)."
    default       = ""
    type          = string 
    sensitive     = true
}

variable "domain_member_sgids"{
    description   = "ID of security groups what you need."
    default       = ""
    type          = string 
}

variable "domain_netbios_name"{
    description   = "NetBIOS name of the domain (up to 15 characters) for users of earlier versions of Windows."
    default       = ""
    type          = string 
    sensitive     = true
}

variable "domain_join_ou"{
    description   = "OU fo the nodes"
    default       = "OU=Computers,DC=nonprod,DC=example,DC=internal"
    type          = string 
    sensitive     = true
}

variable "admin_secrets_arn"{
    description   = "admin secrets"
    default       = ""
    type          = string 
    sensitive     = true
}

variable "sql_secrets_arn"{
    description   = "admin secrets"
    default       = ""
    type          = string 
    sensitive     = true
}

variable "sql_admin_group_name"{
    description   = "The Ad group name for sql sys admin role"
    default       = "Example SQL Server administrators"
    type          = string 
    sensitive     = true
}


variable "key_name"{
    description   = "public/private key pair, which allows you to securely connect to your instance after it launches."
    default       = ""
    type          = string 
    sensitive     = true
}

variable "ebs_kms_key"{
    description   = "kms key for ebs"
    default       = ""
    type          = string 
    sensitive     = true
}

variable "private_subnet_1"{
    description   = "ID of the private subnet 1 in Availability Zone 1 (e.g., subnet-846633ac)."
    default       = ""
    type          = string 
}

variable "private_subnet_2"{
    description   = "ID of the private subnet 1 in Availability Zone 2 (e.g., subnet-846633ac)."
    default       = ""
    type          = string 
}


variable "private_subnet_3"{
    description   = "ID of the private subnet 1 in Availability Zone 3(e.g., subnet-846633ac)."
    default       = ""
    type          = string 
}

variable "qs_s3_bucket_name"{
    description   = " S3 bucket name for the Quick Start assets. This name can include numbers, lowercase letters, uppercase letters, and hyphens (-).It cannot start or end with a hyphen (-)."
    default       = ""
    type          = string 
}

variable "qs_s3_key_prefix"{
    description   = "S3 key prefix for the Quick Start assets. This prefix can include numbers, lowercase letters, uppercase letters, hyphens (-), and forward slash (/)."
    default       = ""
    type          = string 
}

variable "sql_license_provided" {
    description   = "License SQL Server from AWS Marketplace."
    default       = null
}


variable "sql_server_version" {
    description   = "Version of SQL Server to install on failover cluster nodes. 2017 or 2016"
    default       = "2019"
    type          = string 
}


variable "is_two_node" {
    description   = "two node cluster?"
    default       = true
    type          = bool
}

variable "volume_1_iops" {
    default       = 3000
    description   = "IOPS for the Data (Disk - D) drive."
    type          = number
}

variable "volume_1_size" {
    default       = 250
    description   = "Volume size for the Data (Disk - D) drive, in GiB."
    type          = number
}

variable "volume_1_type" {
    default       = "gp3"
    description   = "Volume type for the Data (Disk - D) drive. Valid inputs are gp2 or io1"
    type          = string
}

variable "volume_2_iops" {
    default       = 6000
    description   = "IOPS for the Logs (Disk - L) drive."
    type          = number
}

variable "volume_2_size" {
    default       = 6000
    description   = "Volume size for the Logs (Disk - L) drive, in GiB."
    type          = number
}

variable "volume_2_type" {
    default       = "gp3"
    description   = "Volume type for the Logs (Disk - L) drive. Valid inputs are gp2 or io1"
    type          = string
}

variable "volume_3_iops" {
    default       = 3000
    description   = "IOPS for the windows server (Disk - Y) drive."
    type          = number
}

variable "volume_3_size" {
    default       = 250
    description   = "Volume size for the windows server (Disk - Y) drive, in GiB."
    type          = number
}

variable "volume_3_type" {
    default       = "gp3"
    description   = "Volume type for the windows server (Disk - Y) drive. Valid inputs are gp2 or io1"
    type          = string
}


variable "volume_4_iops" {
    default       = 3000
    description   = "IOPS for the Zephyr (Disk - Z) drive."
    type          = number
}

variable "volume_4_size" {
    default       = 250
    description   = "Volume size for the Zephyr (Disk - Z) drive, in GiB."
    type          = number
}

variable "volume_4_type" {
    default       = "gp3"
    description   = "Volume type for the Zephyr (Disk - Z) drive. Valid inputs are gp2 or io1"
    type          = string
}


variable "volume_5_iops" {
    default       = 3000
    description   = "IOPS for the SQL Server (Disk - Z) drive."
    type          = number
}

variable "volume_5_size" {
    default       = 250
    description   = "Volume size for the SQL Server (Disk - Z) drive, in GiB."
    type          = number
}

variable "volume_5_type" {
    default       = "gp3"
    description   = "Volume type for the SQL Server (Disk - Z) drive. Valid inputs are gp2 or io1"
    type          = string
}

variable "volume_6_iops" {
    default       = 3000
    description   = "IOPS for the SQL Server (Disk - Z) drive."
    type          = number
}

variable "volume_6_size" {
    default       = 250
    description   = "Volume size for the SQL Server (Disk - Z) drive, in GiB."
    type          = number
}

variable "volume_6_type" {
    default       = "gp3"
    description   = "Volume type for the SQL Server (Disk - Z) drive. Valid inputs are gp2 or io1"
    type          = string
}


variable "vpc_id" {
    default       = ""
    description   = "id of the vpc"
    type          = string
}

variable "wsfc_node1_instance_type" {
    default       = "r5b.2xlarge"
    description   = "Amazon EC2 instance type for the first WSFC node."
    type          = string
}

variable "wsfc_node1_netbios_name" {
    default       = ""
    description   = "NetBIOS name of the first WSFC node (up to 15 characters)."
    type          = string
}



variable "wsfc_node2_instance_type" {
    default       = "r5a.large"
    description   = "Amazon EC2 instance type for the 2nd WSFC node."
    type          = string
}

variable "wsfc_node2_netbios_name" {
    default       = ""
    description   = "NetBIOS name of the 2nd WSFC node (up to 15 characters)."
    type          = string
}

variable "wsfc_node2_private_ip_1" {
    default       = ""
    description   = "Primary private IP for the 2nd WSFC node located in Availability Zone 1."
    type          = string
}


variable "tags" {
    description   = "tags for the resources"
    type          = map(string)

}


variable "cloudwatch_kms_key_id" {
    description   = "KMS Key id for cloudwatch logs"
    type          = string
    default       = ""

}
variable "cloudwatch_retention_in_days" {
    description   = "Retention in days for cloudwatch logs"
    type          = number
    default       = 120

}


variable "fsx_kms_key" {
    description   = "kms key for fsx"
    type          = string
    default       = null

}





