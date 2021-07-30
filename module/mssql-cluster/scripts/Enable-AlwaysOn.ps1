[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]$DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminPassword,

    [Parameter(Mandatory=$true)]
    [string]$WSFCNode1NetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]$WSFCNode2NetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]$WSFCNode3NetBIOSName=$null

)
$success = $false
For ($i=0; $i -le 4; $i++) {
    if ($success -eq $true) {
        Break
    }

    try {
        Start-Transcript -Path C:\cfn\log\Enable-SqlAlwaysOn.ps1.txt -Append
        $ErrorActionPreference = "Stop"

        $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
        $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
        $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)

        $EnableAlwaysOnPs={
            $ErrorActionPreference = "Stop"
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
            Enable-SqlAlwaysOn -ServerInstance $Using:serverInstance -Force
        }

        $serverInstance = $WSFCNode1NetBIOSName
        Invoke-Command -Scriptblock $EnableAlwaysOnPs -ComputerName $WSFCNode1NetBIOSName -Credential $DomainAdminCreds
        $serverInstance = $WSFCNode2NetBIOSName
        Invoke-Command -Scriptblock $EnableAlwaysOnPs -ComputerName $WSFCNode2NetBIOSName -Credential $DomainAdminCreds
        if ($WSFCNode3NetBIOSName) {
            $serverInstance = $WSFCNode3NetBIOSName
            Invoke-Command -Scriptblock $EnableAlwaysOnPs -ComputerName $WSFCNode3NetBIOSName -Credential $DomainAdminCreds
        }

        $success = $true

    }
    catch {
        if ($i -eq 3) {
            $_ | Write-AWSQuickStartException
        }
        else {
            $success = $false
        }
    }

    Start-Sleep -s 300
}


