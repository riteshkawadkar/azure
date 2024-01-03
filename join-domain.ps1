$domain = "mylab.local"
$username = "adminuser"
$securePassword = "NewMinal@123" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Add-Computer -DomainName $domain -Credential $credential





