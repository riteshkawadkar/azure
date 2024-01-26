# Check if .NET Framework 4.8 is installed
$dotNetFrameworkVersion = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -Name Release
if ($dotNetFrameworkVersion.Release -ge 528040) {
    Write-Host ".NET Framework 4.8 is already installed."
} else {
    # Download and install .NET Framework 4.8
    # https://download.visualstudio.microsoft.com/download/pr/3a3ff58d-2043-4dc9-a47f-44e703cd9a36/06b0170df2fca8935cd0ef002d25a5f1/ndp48-x86-x64-allos-enu.exe
    $dotNetFrameworkInstallerUrl = 'https://go.microsoft.com/fwlink/?linkid=2088631'
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
