# PowerShell script to install AD DS role and promote to Domain Controller

# Define variables
$domainName = "mylab.local" # Your domain name
$staticIP = "10.0.0.4" # Static IP for the DC, aligned with Azure subnet
$dnsIP = "10.0.0.4" # DNS IP, typically the same as the DC for the first DC
$safeModeAdminPassword = ConvertTo-SecureString "SafeModePa$$w0rd" -AsPlainText -Force # Safe mode password

# Install the AD DS role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Configure the server's IP address to static (align with Azure VNet)
New-NetIPAddress -IPAddress $staticIP -PrefixLength 24 -DefaultGateway 10.0.0.1 # Adjust gateway as needed
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsIP

# Promote the server to a domain controller
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainName $domainName `
    -DomainNetbiosName (Get-Culture).TextInfo.ToUpper($domainName.Split('.')[0]) `
    -ForestMode "WinThreshold" ` # Replace with your desired forest mode
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $safeModeAdminPassword

# Reboot the server to complete the installation
Restart-Computer
