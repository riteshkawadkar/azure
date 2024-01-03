# extension_script.ps1
$domainName="mylab.local"
$adminUsername="adminuser"
$adminPassword="NewMinal@123" 
$securePassword = ConvertTo-SecureString -String $adminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $adminUsername, $securePassword
Add-Computer -DomainName $domainName -Credential $credential
