# domain_join.ps1

# Domain to join
$domain = "mylab.local"

# Credentials for domain join
$domainUsername = "mylab.local\adminuser"  # Replace DOMAIN\username with actual domain admin username
$domainPassword = "NewMinal@123" | ConvertTo-SecureString -AsPlainText -Force  # Replace password with actual domain admin password
$credential = New-Object System.Management.Automation.PSCredential($domainUsername, $domainPassword)

# Join the domain
Add-Computer -DomainName $domain -Credential $credential -Force -Restart
