# extension_script.ps1
$domainName="mylab.local"
$adminUsername="adminuser"
$adminPassword="NewMinal@123" 
$securePassword = ConvertTo-SecureString -String "$adminPassword" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$adminUsername", "$securePassword")
Add-Computer -DomainName $domainName -Credential $credential
