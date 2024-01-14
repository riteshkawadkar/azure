# Check if .NET Framework 4.8 is installed
$dotNetFrameworkVersion = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -Name Release
if ($dotNetFrameworkVersion.Release -ge 528040) {
    Write-Host ".NET Framework 4.8 is already installed."
} else {
    # Download and install .NET Framework 4.8
    $dotNetFrameworkInstallerUrl = 'https://download.visualstudio.microsoft.com/download/pr/3a3ff58d-2043-4dc9-a47f-44e703cd9a36/06b0170df2fca8935cd0ef002d25a5f1/ndp48-x86-x64-allos-enu.exe'
    $dotNetFrameworkInstallerPath = "$env:TEMP\dotNetFrameworkInstaller.exe"

    Invoke-WebRequest -Uri $dotNetFrameworkInstallerUrl -OutFile $dotNetFrameworkInstallerPath -UseBasicParsing
    Start-Process -FilePath $dotNetFrameworkInstallerPath -ArgumentList '/quiet', '/norestart' -Wait
    Remove-Item -Path $dotNetFrameworkInstallerPath -Force
}

# Install Chocolatey
if ((Get-Command -Name 'choco' -ErrorAction SilentlyContinue) -eq $null) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

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
choco install dotnet-6.0-windowshosting

# text editors
Write-Host "====> Installing text editors..."
choco install notepadplusplus -y

# ides
Write-Host "====> Installing IDEs..."
choco install visualstudio2022buildtools -y
choco install visualstudio2022professional -y --package-parameters "--includeRecommended --locale en-US --passive --add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCoreTools --add Microsoft.VisualStudio.Workload.DataStorageAndProcessing  --add Microsoft.VisualStudio.Workload.NativeCrossPlat --add Component.GitHub.VisualStudio  --add Microsoft.VisualStudio.Workload.ManagedDesktop "


# ide extensions
Write-Host "====> Installing IDE extensions..."
choco install visualassist -y

# additional softwares
Write-Host "====> Installing additional softwares..."
choco install postman -y
choco install fiddler -y
choco install sysinternals -y


# Install IIS
$features = @("Web-Windows-Auth", "Web-Url-Auth", "Web-Net-Ext", "Web-ASP", "Web-ISAPI-Ext", "Web-Includes")

foreach($feature in $features){
   Install-WindowsFeature -Name $feature -IncludeManagementTools -IncludeAllSubFeature
}


# Start the World Wide Web Publishing Service
Start-Service W3SVC
