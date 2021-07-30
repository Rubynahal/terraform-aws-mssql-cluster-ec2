<powershell>
$DefaultGateway=(Get-NetIPConfiguration -Interfacealias "ethernet 2").Ipv4defaultgateway.nexthop
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Disabled; New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "${WSFCNode2PrivateIP1}" -PrefixLength 24 -DefaultGateway $DefaultGateway -skipassource $false; Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("${DomainDNSServer1}", "${DomainDNSServer2}")
Start-SSMAutomationExecution -DocumentName "${documentname}" `
-Parameter @{"SQLServerVersion"="${SQLServerVersion}";`
"SQLLicenseProvided"="${SQLLicenseProvided}";`
"WSFCNode1NetBIOSName"="${WSFCNode1NetBIOSName}";`
"WSFCNode1PrivateIP1"="${WSFCNode1PrivateIP1}";`
"WSFCNode1PrivateIP2"="${WSFCNode1PrivateIP2}";`
"WSFCNode1PrivateIP3"="${WSFCNode1PrivateIP3}";`
"WSFCNode2NetBIOSName"="${WSFCNode2NetBIOSName}";`
"WSFCNode2PrivateIP1"="${WSFCNode2PrivateIP1}";`
"WSFCNode2PrivateIP2"="${WSFCNode2PrivateIP2}";`
"WSFCNode2PrivateIP3"="${WSFCNode2PrivateIP3}";`
"FSXFileSystemID"="${FSXFileSystem}";`
"ClusterName"="${ClusterName}";`
"AvailabiltyGroupName"="${AvailabiltyGroupName}";`
"AvailabiltyGroupListenerName"="${AvailabiltyGroupListenerName}";`
"ThirdAZ"="${ThirdAZ}";`
"DomainDNSName"="${DomainDNSName}";`
"DomainNetBIOSName"="${DomainNetBIOSName}";`
"DomainJoinOU"="${DomainJoinOU}";`
"DomainDNSServer1"="${DomainDNSServer1}";`
"DomainDNSServer2"="${DomainDNSServer2}";`
"ManagedAD"="yes";`
"AdminSecrets"="${ADAdminSecrets}";`
"SQLSecrets"="${SQLSecrets}";`
"SQLAdminGroup"="${SQLAdminGroup}";`
"QSS3BucketName"="${QSS3BucketName}";`
"QSS3KeyPrefix"="${QSS3KeyPrefix}";`
"SQL2016Media"="${SQL2016Media}";`
"SQL2017Media"="${SQL2017Media}";`
"SQL2019Media"="${SQL2019Media}";`
"StackName"="";`
"WitnessType"="FSx";`
"URLSuffix"="amazonaws.com";`
"AutomationAssumeRole"="${AWSQuickstartMSSQLRole}";`
"CloudwatchLogGroup"="${CloudwatchLogGroup}"}
</powershell>
