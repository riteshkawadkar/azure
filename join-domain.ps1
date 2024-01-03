$domain = "mylab.local"
$username = "adminuser"
$password = "NewMinal@123" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $domainUser, $securePassword

Add-Computer -DomainName $domain -Credential $credential





