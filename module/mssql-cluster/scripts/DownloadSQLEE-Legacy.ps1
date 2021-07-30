[CmdletBinding()]

param(

    [Parameter(Mandatory=$true)]
    [string]
    $DestShare,

    [Parameter(Mandatory=$true)]
    [string]
    $DestServer,

    [Parameter(Mandatory=$true)]
    [string]
    $SQLServerVersion

)

try {
    Start-Transcript -Path C:\cfn\log\DownloadSQLEE.ps1.txt -Append

    $ErrorActionPreference = "Stop"

    if($SQLServerVersion -eq "2014") {
        $source = "http://download.microsoft.com/download/6/1/9/619E068C-7115-490A-BFE3-09BFDEF83CB9/SQLServer2014-x64-ENU.iso"
    }
    elseif ($SQLServerVersion -eq "2016") {
        $source = "http://download.microsoft.com/download/F/E/9/FE9397FA-BFAB-4ADD-8B97-91234BC774B2/SQLServer2016-x64-ENU.iso"
        $ssmssource = "http://download.microsoft.com/download/4/7/2/47218E85-5903-4EF4-B54E-3B71DD558017/SSMS-Setup-ENU.exe"
    }
    else {
        $source = "http://download.microsoft.com/download/3/B/D/3BD9DD65-D3E3-43C3-BB50-0ED850A82AD5/SQLServer2012SP1-FullSlipstream-ENU-x64.iso"
    }

    $tries = 5
    while ($tries -ge 1) {
        try {
            Start-BitsTransfer -Source $source -Destination "\\$DestServer\$DestShare\" -ErrorAction Stop
            if ($SQLServerVersion -eq "2016") {
                Start-BitsTransfer -Source $ssmssource -Destination "\\$DestServer\$DestShare\" -ErrorAction Stop
            }
            break
        }
        catch {
            $tries--
            Write-Verbose "Exception:"
            Write-Verbose "$_"
            if ($tries -lt 1) {
                throw $_
            }
            else {
                Write-Verbose "Failed download. Retrying again in 5 seconds"
                Start-Sleep 5
            }
        }
    }
}
catch {
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}
