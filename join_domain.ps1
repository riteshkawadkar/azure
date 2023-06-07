# Get the network adapter
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

# Set the DNS server IP address (replace 'x.x.x.x' with the IP address of your domain controller)
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses 'x.x.x.x'

# Join the VM to the domain
Add-Computer -DomainName 'test.local' -Credential (Get-Credential)

# Restart the VM
Restart-Computer
