# choco installation
# https://chocolatey.org/install

Write-Host "=== Creating your development environment! ==="

Write-Host "====> Installing Choco packages..."
choco --version
choco feature enable -name=exitOnRebootDetected

# core components - https://github.com/dotnetcore-chocolatey/dotnetcore-chocolateypackages
Write-Host "====> Installing core components..."
choco install git -y
choco install dotnet-6.0-sdk -y
choco install dotnet-6.0-windowshosting -y

# text editors
Write-Host "====> Installing text editors..."
choco install notepadplusplus -y

# ides
Write-Host "====> Installing IDEs..."
choco install visualstudio2022buildtools -y
choco install visualstudio2022community -y --package-parameters "--includeRecommended --locale en-US --passive --add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCoreTools --add Microsoft.VisualStudio.Workload.DataStorageAndProcessing  --add Microsoft.VisualStudio.Workload.NativeCrossPlat --add Component.GitHub.VisualStudio  --add Microsoft.VisualStudio.Workload.ManagedDesktop "
# choco install visualstudio2022professional -y --package-parameters "--includeRecommended --locale en-US --passive --add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCoreTools --add Microsoft.VisualStudio.Workload.DataStorageAndProcessing  --add Microsoft.VisualStudio.Workload.NativeCrossPlat --add Component.GitHub.VisualStudio  --add Microsoft.VisualStudio.Workload.ManagedDesktop "


# ide extensions
Write-Host "====> Installing IDE extensions..."
choco install visualassist -y

# additional softwares
Write-Host "====> Installing additional softwares..."
choco install postman -y
choco install fiddler -y
choco install sysinternals -y


# Install IIS
# Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Add-WindowsFeature -Name Web-Windows-Auth, Web-Url-Auth, Web-Net-Ext, Web-ASP, Web-ISAPI-Ext, Web-Includes
# Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature
# Start the World Wide Web Publishing Service
Start-Service W3SVC
