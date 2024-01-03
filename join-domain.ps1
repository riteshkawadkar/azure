# $domain = "mylab.local"
# $username = "adminuser"
# $password = "NewMinal_123" | ConvertTo-SecureString -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Add-Computer -DomainName $domain -Credential $credential 


# Variables
$domainName = "mylab.local"
$domainUser = "adminuser"
$domainPassword = "NewMinal@123"


# Domain join
$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
$domainCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $domainUser, $securePassword
Add-Computer -DomainName $domainName -Credential $domainCredential -Force -Restart





