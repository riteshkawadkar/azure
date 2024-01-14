# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Start the World Wide Web Publishing Service
Start-Service W3SVC
