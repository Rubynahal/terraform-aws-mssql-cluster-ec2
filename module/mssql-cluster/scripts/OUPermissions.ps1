[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]$DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]$DomainDNSName,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminPassword
)

Function Get-Domain {
	
	#Retrieve the Fully Qualified Domain Name if one is not supplied
	# division.domain.root
	if ($DomainDNSName -eq "") {
		[String]$DomainDNSName = [System.DirectoryServices.ActiveDirectory.Domain]::getcurrentdomain()
	}

	# Create an Array 'Item' for each item in between the '.' characters
	$FQDNArray = $DomainDNSName.split(".")
	
	# Add A Separator of ','
	$Separator = ","

	# For Each Item in the Array
	# for (CreateVar; Condition; RepeatAction)
	# for ($x is now equal to 0; while $x is less than total array length; add 1 to X
	for ($x = 0; $x -lt $FQDNArray.Length ; $x++)
		{ 

		#If it's the last item in the array don't append a ','
		if ($x -eq ($FQDNArray.Length - 1)) { $Separator = "" }
		
		# Append to $DN DC= plus the array item with a separator after
		[string]$DN += "DC=" + $FQDNArray[$x] + $Separator
		
		# continue to next item in the array
		}
	
	#return the Distinguished Name
	return $DN
}

Function Convert-CidrtoSubnetMask { 
    Param ( 
        [String] $SubnetMaskCidr
    ) 

    Function Convert-Int64ToIpAddress() { 
      Param 
      ( 
          [int64] 
          $Int64 
      ) 
   
      # Return 
      '{0}.{1}.{2}.{3}' -f ([math]::Truncate($Int64 / 16777216)).ToString(), 
          ([math]::Truncate(($Int64 % 16777216) / 65536)).ToString(), 
          ([math]::Truncate(($Int64 % 65536)/256)).ToString(), 
          ([math]::Truncate($Int64 % 256)).ToString() 
    } 
 
    # Return
    Convert-Int64ToIpAddress -Int64 ([convert]::ToInt64(('1' * $SubnetMaskCidr + '0' * (32 - $SubnetMaskCidr)), 2)) 
}

Function Get-CIDR {
    Param ( 
        [String] $Target
    ) 
    Invoke-Command -ComputerName $Target -Credential $Credentials -Scriptblock {(Get-NetIPConfiguration).IPv4Address.PrefixLength[0]}
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName     = 'localhost'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
            InstanceName         = 'MSSQLSERVER'
            AvailabilityGroupName = 'SQLAG1'
            ProcessOnlyOnActiveNode = $true
        }
    )
}

Configuration OUPermissions {
    param(

        [Parameter(Mandatory = $true)]
        [PSCredential]$Credentials
    )

    Import-Module -Name PSDesiredStateConfiguration
    Import-Module -Name xActiveDirectory
    Import-Module -Name SqlServerDsc
    
    Import-DscResource -Module PSDesiredStateConfiguration
    Import-DscResource -Module xActiveDirectory
    Import-DscResource -Module SqlServerDsc

    Node 'localhost' {
        WindowsFeature RSAT-ADDS-Tools {
            Name = 'RSAT-ADDS-Tools'
            Ensure = 'Present'
        }
    
        xADObjectPermissionEntry ADObjectPermissionEntry {
            Ensure                             = 'Present'
            Path                               = $OUPath
            IdentityReference                  = $IdentityReference
            ActiveDirectoryRights              = 'GenericAll'
            AccessControlType                  = 'Allow'
            ObjectType                         = '00000000-0000-0000-0000-000000000000'
            ActiveDirectorySecurityInheritance = 'All'
            InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
            PsDscRunAsCredential               = $Credentials
        }
    }
}


$AdminUser = $DomainNetBIOSName + '\' + $DomainAdminUser
$Credentials = (New-Object System.Management.Automation.PSCredential($AdminUser,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force)))

$DN = Get-Domain
$IdentityReference = $DomainNetBIOSName + "\WSFCluster1$"
$OUPath = 'OU=Computers,OU=' + $DomainNetBIOSName + "," + $DN

OUPermissions -OutputPath 'C:\cfn\scripts\OUPermissions' -Credentials $Credentials -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path 'C:\cfn\scripts\OUPermissions' -Wait -Verbose -Force
