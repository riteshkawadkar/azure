Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools -Include Web-Windows-Auth, Web-Url-Auth, Web-Net-Ext, Web-ASP, Web-ISAPI-Ext, Web-Includes

# Start the World Wide Web Publishing Service
Start-Service W3SVC
