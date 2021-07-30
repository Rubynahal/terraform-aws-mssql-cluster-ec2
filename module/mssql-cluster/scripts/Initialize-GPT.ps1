[CmdletBinding()]
param()

# Getting the DSC Cert Encryption Thumbprint to Secure the MOF File
$DscCertThumbprint = (get-childitem -path cert:\LocalMachine\My | where { $_.subject -eq "CN=AWSQSDscEncryptCert" }).Thumbprint

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            CertificateFile = "C:\AWSQuickstart\publickeys\AWSQSDscPublicKey.cer"
            Thumbprint = $DscCertThumbprint
            PSDscAllowDomainUser = $true
        },
        @{
            NodeName = 'localhost'
        }
    )
}

Configuration Disk_InitializeDataDisk
{
    Import-DSCResource -ModuleName StorageDsc

    Node localhost {
        WaitForDisk Disk1 {
             DiskId = 1
             RetryIntervalSec = 60
             RetryCount = 60
        }

        Disk DVolume {
             DiskId = 1
             DriveLetter = 'D'
             PartitionStyle = 'GPT'
             FSFormat = 'NTFS'
             AllocationUnitSize = 64KB
             AllowDestructive = $true
             DependsOn = '[WaitForDisk]Disk2'
             ClearDisk = $true
             FSLabel = 'Data01'
        }

        WaitForDisk Disk2 {
             DiskId = 2
             RetryIntervalSec = 60
             RetryCount = 60
        }

        Disk EVolume {
             DiskId = 2
             DriveLetter = 'E'
             PartitionStyle = 'GPT'
             FSFormat = 'NTFS'
             AllocationUnitSize = 64KB
             AllowDestructive = $true
             DependsOn = '[WaitForDisk]Disk2'
             ClearDisk = $true
             FSLabel = 'Data02'
        }

        WaitForDisk Disk3 {
            DiskId = 3
            RetryIntervalSec = 60
            RetryCount = 60
       }

       Disk KVolume {
            DiskId = 3
            DriveLetter = 'K'
            PartitionStyle = 'GPT'
            FSFormat = 'NTFS'
            AllocationUnitSize = 64KB
            AllowDestructive = $true
            DependsOn = '[WaitForDisk]Disk3'
            ClearDisk = $true
            FSLabel = 'Backup01'
       }

       WaitForDisk Disk4 {
            DiskId = 4
            RetryIntervalSec = 60
            RetryCount = 60
       }

       Disk LVolume {
            DiskId = 4
            DriveLetter = 'L'
            PartitionStyle = 'GPT'
            FSFormat = 'NTFS'
            AllocationUnitSize = 64KB
            AllowDestructive = $true
            DependsOn = '[WaitForDisk]Disk4'
            ClearDisk = $true
            FSLabel = 'Log01'
       }

       WaitForDisk Disk5 {
            DiskId = 5
            RetryIntervalSec = 60
            RetryCount = 60
       }

       Disk SVolume {
            DiskId = 5
            DriveLetter = 'S'
            PartitionStyle = 'GPT'
            FSFormat = 'NTFS'
            AllocationUnitSize = 64KB
            AllowDestructive = $true
            DependsOn = '[WaitForDisk]Disk5'
            ClearDisk = $true
            FSLabel = 'System01'
       }

       WaitForDisk Disk6 {
            DiskId = 6
            RetryIntervalSec = 60
            RetryCount = 60
       }

       Disk TVolume {
            DiskId = 6
            DriveLetter = 'T'
            PartitionStyle = 'GPT'
            FSFormat = 'NTFS'
            AllocationUnitSize = 64KB
            AllowDestructive = $true
            DependsOn = '[WaitForDisk]Disk6'
            ClearDisk = $true
            FSLabel = 'Tempdb01'
       }
    }
}

Disk_InitializeDataDisk -OutputPath 'C:\AWSQuickstart\InitializeDisk' -ConfigurationData $ConfigurationData

Start-DscConfiguration 'C:\AWSQuickstart\InitializeDisk' -Wait -Verbose -Force