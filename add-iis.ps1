Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# choco installation
# https://chocolatey.org/install

Write-Host "=== Creating your development environment! ==="

Write-Host "====> Installing Choco packages..."
choco --version
choco feature enable -name=exitOnRebootDetected


# core components
Write-Host "====> Installing core components..."
choco install git -y
choco install dotnet-sdk --version=6.0.1 -y


# text editors
Write-Host "====> Installing text editors..."
choco install notepadplusplus -y

# browsers
Write-Host "====> Installing web browsers..."
choco install GoogleChrome -y

# git gui softwares
Write-Host "====> Installing git gui softwares..."
choco install git-fork -y


# ides
Write-Host "====> Installing IDEs..."
choco install visualstudio2022buildtools -y
choco install visualstudio2022professional -y --package-parameters "--includeRecommended --locale en-US --passive --add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCoreTools --add Microsoft.VisualStudio.Workload.DataStorageAndProcessing  --add Microsoft.VisualStudio.Workload.NativeCrossPlat --add Component.GitHub.VisualStudio  --add Microsoft.VisualStudio.Workload.ManagedDesktop "


# ide extensions
Write-Host "====> Installing IDE extensions..."
choco install cppcheck -y
choco install visualassist -y

# additional softwares
Write-Host "====> Installing additional softwares..."
choco install postman -y
choco install fiddler -y



# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools -Include Web-Windows-Auth, Web-Url-Auth, Web-Net-Ext, Web-ASP, Web-ISAPI-Ext, Web-Includes

# Start the World Wide Web Publishing Service
Start-Service W3SVC
