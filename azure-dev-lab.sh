#!/bin/bash

# Variables
resourceGroup="MyRG"
location="centralindia"
vnetName="MyVNet"
subnetName="MySubnet"
nsgName="MyNSG"

# Domain Controller
dcVmName="DCVM"
dcAdminUsername="adminuser"
dcAdminPassword="NewMinal@123" 

# IIS Server VM
iisVmName="IISVM"
iisAdminUsername="iisuser"
iisAdminPassword="NewMinal@123" 

# Windows 10 Client VM
tenVmName="TENVM"
tenAdminUsername="tenuser"
tenAdminPassword="NewMinal@123" 

# Windows 11 Client VM
elevenVmName="ELEVENVM"
elevenAdminUsername="elevenuser"
elevenAdminPassword="NewMinal@123" 

elevenVmName22H2="ELEVENVM"
elevenAdminUsername="elevenuser"
elevenAdminPassword="NewMinal@123" 

vmSize="Standard_E2s_v3"
domainName="mylab.local"
jsonFilePath = "C:\Users\rites\Downloads\server\dc_settings.json"

# Variables for the PowerShell script
dcConfigScriptUri="https://raw.githubusercontent.com/riteshkawadkar/azure/main/install_ad_ds_and_forest.ps1" 
vmConfigScriptUri="https://raw.githubusercontent.com/riteshkawadkar/azure/main/join-domain.ps1" 
vmIISAndAppsUri="https://raw.githubusercontent.com/riteshkawadkar/azure/main/add-iis-and-install-apps.ps1" 
vmAddchoco="https://raw.githubusercontent.com/riteshkawadkar/azure/main/add-choco.ps1" 
vmOUUserGroupConfigScriptUri="https://raw.githubusercontent.com/riteshkawadkar/azure/main/ActiveDirectry_Lab_Scripts/create-ou-group-user.ps1"
vmAddUsersWithRDPUri="https://raw.githubusercontent.com/riteshkawadkar/azure/main/add_users_and_grant_rdp.ps1"



echo "Creating Resource Group: $resourceGroup"
az group create --name "$resourceGroup" --location "$location"

echo "Creating Virtual Network: $vnetName and Subnet: $subnetName"
az network vnet create --resource-group "$resourceGroup" --name "$vnetName" --address-prefix 10.0.0.0/16 --subnet-name "$subnetName" --subnet-prefix 10.0.0.0/24

echo "Creating Network Security Group: $nsgName"
az network nsg create --resource-group "$resourceGroup" --name "$nsgName"

echo "Creating a Network Security Rule to allow all internetwork traffic on NSG: $nsgName"
az network nsg rule create --resource-group "$resourceGroup" --nsg-name "$nsgName" --name AllowAllTraffic --priority 100 --direction Inbound --access Allow --protocol "*" --source-port-range "*" --destination-port-range "*" --source-address-prefix "*" --destination-address-prefix "*"

echo "Creating Windows Server 2019 VM for Domain Controller"
az vm create --resource-group "$resourceGroup" --name "$dcVmName" --image Win2019Datacenter --admin-username "$dcAdminUsername" --admin-password "$dcAdminPassword" --size "$vmSize" --nsg "$nsgName"


serverPublicIP=$(az vm show -d -g $resourceGroup -n "$dcVmName" --query publicIps -o tsv)
serverPrivateIP=$(az vm show -d --resource-group $resourceGroup --name "$dcVmName" --query "privateIps" -o tsv)
echo "Server Public IP Address: $serverPublicIP"
echo "Server Private IP Address: $serverPrivateIP"


echo "Updating custom DNS Server in VNet: $vnetName"
az network vnet update --name myvnet --resource-group "$resourceGroup" --set dhcpOptions.dnsServers="[\"$serverPrivateIP\"]"

echo "Configuring the VM as a Domain Controller"
az vm extension set --resource-group "$resourceGroup" --vm-name "$dcVmName" --name CustomScriptExtension --publisher Microsoft.Compute --settings "{ \"fileUris\": [\"$dcConfigScriptUri\"], \"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File install_ad_ds_and_forest.ps1\" }"

echo "Restart the domain controller VM"
az vm restart --resource-group "$resourceGroup" --name "$dcVmName"


# Add rules for additional ports
az network nsg rule create --resource-group "$resourceGroup" --nsg-name "$nsgName" \
    --name AllowPort8080 --priority 110 --direction Inbound --access Allow \
    --protocol Tcp --source-port-range "*" --destination-port-range 8080 \
    --source-address-prefix "*" --destination-address-prefix "*"

az network nsg rule create --resource-group "$resourceGroup" --nsg-name "$nsgName" \
    --name AllowPort8081 --priority 120 --direction Inbound --access Allow \
    --protocol Tcp --source-port-range "*" --destination-port-range 8081 \
    --source-address-prefix "*" --destination-address-prefix "*"

az network nsg rule create --resource-group "$resourceGroup" --nsg-name "$nsgName" \
    --name AllowPort8082 --priority 130 --direction Inbound --access Allow \
    --protocol Tcp --source-port-range "*" --destination-port-range 8082 \
    --source-address-prefix "*" --destination-address-prefix "*"


# For port 4430
az network nsg rule create \
    --resource-group "MyRG" \
    --nsg-name "MyNSG" \
    --name "Allow-4430" \
    --priority 400 \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --source-address-prefix "*" \
    --source-port-range "*" \
    --destination-address-prefix "*" \
    --destination-port-range 4430

# For port 4431
az network nsg rule create \
    --resource-group "MyRG" \
    --nsg-name "MyNSG" \
    --name "Allow-4431" \
    --priority 410 \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --source-address-prefix "*" \
    --source-port-range "*" \
    --destination-address-prefix "*" \
    --destination-port-range 4431

# For port 4432
az network nsg rule create \
    --resource-group "MyRG" \
    --nsg-name "MyNSG" \
    --name "Allow-4432" \
    --priority 420 \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --source-address-prefix "*" \
    --source-port-range "*" \
    --destination-address-prefix "*" \
    --destination-port-range 4432

az network nsg rule create \
    --resource-group "MyRG" \
    --nsg-name "MyNSG" \
    --name "Allow-5341" \
    --priority 534 \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --source-address-prefix "*" \
    --source-port-range "*" \
    --destination-address-prefix "*" \
    --destination-port-range 5341

# RUn on VM
# New-NetFirewallRule -DisplayName "Allow-4430" -Direction Inbound -Protocol TCP -LocalPort 4430 -Action Allow
# New-NetFirewallRule -DisplayName "Allow-4431" -Direction Inbound -Protocol TCP -LocalPort 4431 -Action Allow
# New-NetFirewallRule -DisplayName "Allow-4432" -Direction Inbound -Protocol TCP -LocalPort 4432 -Action Allow
# New-NetFirewallRule -DisplayName "Allow-8080" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
# New-NetFirewallRule -DisplayName "Allow-8081" -Direction Inbound -Protocol TCP -LocalPort 8081 -Action Allow
# New-NetFirewallRule -DisplayName "Allow-8082" -Direction Inbound -Protocol TCP -LocalPort 8082 -Action Allow
# New-NetFirewallRule -DisplayName "Allow-5341" -Direction Inbound -Protocol TCP -LocalPort 5341 -Action Allow


# find ne wimages
az vm image list --publisher "MicrosoftWindowsDesktop" --offer "Windows-10" --all --output table


echo "Creating Windows 10 Client VM"
az vm create   --resource-group "$resourceGroup"   --name "$tenVmName"   --image "MicrosoftWindowsDesktop:Windows-10:win10-22h2-pro:latest"   --admin-username "$tenAdminUsername"   --admin-password "$tenAdminPassword"   --size "$vmSize"   --nsg "$nsgName"

# Creating Windows 11 Client VM
echo "Creating Windows 11 Client VM"
az vm create --resource-group "$resourceGroup" --name "$elevenVmName" --image "MicrosoftWindowsDesktop:windows-11:win11-23h2-pro:latest" --admin-username "$elevenAdminUsername" --admin-password "$elevenAdminPassword" --size "$vmSize" --nsg "$nsgName"
echo "Creating Windows 11 22H2 Client VM"
az vm create --resource-group "$resourceGroup" --name "$elevenVmName22H2" --image "MicrosoftWindowsDesktop:windows-11:win11-22h2-pro:latest" --admin-username "$elevenAdminUsername" --admin-password "$elevenAdminPassword" --size "$vmSize" --nsg "$nsgName"
az vm create --resource-group "$resourceGroup" --name "$elevenVmName22H2" --image "MicrosoftWindowsDesktop:windows-11:win11-21h2-pro:latest" --admin-username "$elevenAdminUsername" --admin-password "$elevenAdminPassword" --size "$vmSize" --nsg "$nsgName"

echo "Creating IIS Server VM"
az vm create --resource-group "$resourceGroup" --name "$iisVmName" --image Win2019Datacenter --admin-username "$iisAdminUsername" --admin-password "$iisAdminPassword" --size "$vmSize" --nsg "$nsgName"


echo "Wait for the domain controller and WIndows VM to restart"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$dcVmName"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$tenVmName"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$elevenVmName"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$iisVmName"

echo "Add Multiple user to Windows 11"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$elevenVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmAddUsersWithRDPUri\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File add_users_and_grant_rdp.ps1\"}"

echo "Joining Windows 11 to Domain"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$elevenVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmConfigScriptUri\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File join-domain.ps1\"}"


# echo "Adding USers on Windows 10 VM and granting them RDP Access"
# az vm extension set --publisher Microsoft.Compute --version 1.9 --name CustomScriptExtension --vm-name "$tenVmName" --resource-group $resourceGroup --settings "{\"fileUris\": [\"$vmAddUsersWithRDPUri\"]}" --protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File add_users_and_grant_rdp.ps1\"}"


echo "Joining Windows 11 to Domain"
az vm extension set --resource-group "$resourceGroup" --vm-name "$elevenVmName" --name CustomScriptExtension --publisher Microsoft.Compute --settings "{ \"fileUris\": [\"$vmConfigScriptUri\"], \"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File join-domain.ps1\" }"
az vm extension set --resource-group "$resourceGroup" --vm-name "$elevenVmName22H2" --name CustomScriptExtension --publisher Microsoft.Compute --settings "{ \"fileUris\": [\"$vmConfigScriptUri\"], \"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File join-domain.ps1\" }"


echo "Joining IIS VM to Domain"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$iisVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmConfigScriptUri\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File join-domain.ps1\"}"

echo "Adding Dot Net 4.8 and choco"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$iisVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmAddchoco\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File add-choco.ps1\"}"

echo "Restart the IIS VM"
az vm restart --resource-group "$resourceGroup" --name "$iisVmName"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$iisVmName"

echo "Adding Dot Net 4.8 and choco"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$iisVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmAddchoco\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File add-choco.ps1\"}"


echo "Adding IIS Feature"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$iisVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmIISAndAppsUri\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File add-iis-and-install-apps.ps1\"}"

echo "Azure VM setup is complete!"

