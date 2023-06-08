Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment 
Install-ADDSForest -DomainName "test.local" -DomainMode "WinThreshold" -ForestMode "WinThreshold" -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "NewMinal@123" -Force) -Force -NoRebootOnCompletion:$true

# Restart the computer and wait for it to come back online
Restart-Computer

