[CmdletBinding()]

param(

    [Parameter(Mandatory=$true)]
    [string]
    $SQLServerVersion,

    [Parameter()]
    [string]
    $SQL2016Media,

    [Parameter()]
    [string]
    $SQL2017Media,

    [Parameter()]
    [string]
    $SQL2019Media

)

try {
    Start-Transcript -Path C:\AWSQuickstart\log\DownloadSQLEE.ps1.txt -Append

    $ErrorActionPreference = "Stop"

    $DestPath = "C:\SQLMedia"
    New-Item "$DestPath" -Type directory -Force

    $ssmssource = "https://download.microsoft.com/download/3/C/7/3C77BAD3-4E0F-4C6B-84DD-42796815AFF6/SSMS-Setup-ENU.exe"

    if ($SQLServerVersion -eq "2016") {
        $source = $SQL2016Media
    }
    elseif ($SQLServerVersion -eq "2017") {
        $source = $SQL2017Media
    }
    else {
        $source = $SQL2019Media
        $DestPathExe = "C:\SQLMedia\SQL2019-SSEI-Eval.exe"
    }

    $tries = 5
    while ($tries -ge 1) {
        try {
            if ( ($Source.Substring($source.Length-4) -eq ".exe") -or ($Source.Substring($source.Length-4) -eq ".iso") )
                { Start-BitsTransfer -Source $source -Destination "$DestPath"  -ErrorAction Stop } 
            else { 
                Start-BitsTransfer -Source $source -Destination "$DestPathExe"  -ErrorAction Stop

                if ($SQLServerVersion -eq "2019") { 
                    C:\SQLMedia\SQL2019-SSEI-Eval.exe /ACTION=DOWNLOAD /MEDIATYPE=ISO /MEDIAPATH=C:\SQLMedia /Quiet /HideProgressBar
                }

                $Timeout = 600
                $timer = [Diagnostics.Stopwatch]::StartNew()
                while (($timer.Elapsed.TotalSeconds -lt $Timeout) -and (-not (Test-Path "C:\SQLMedia\SQLServer$SQLServerVersion-x64-ENU.iso"))) {
                    Start-Sleep -Seconds 20
                }
                $timer.Stop()
            }

            Start-BitsTransfer -Source $ssmssource -Destination "$DestPath" -ErrorAction Stop
           
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
}

