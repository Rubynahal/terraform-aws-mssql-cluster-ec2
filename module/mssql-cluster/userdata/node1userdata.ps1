<powershell>
$DefaultGateway=(Get-NetIPConfiguration -Interfacealias "ethernet 2").Ipv4defaultgateway.nexthop
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Disabled; New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "${WSFCNode1PrivateIP1}" -PrefixLength 24 -DefaultGateway $DefaultGateway -skipassource $false; Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("${DomainDNSServer1}", "${DomainDNSServer2}")
</powershell>