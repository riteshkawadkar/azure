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


# Promote VM to Domain Controller
# echo "Installing AD on Windows Server 2019 VM and promoting to Domain Controller"
# az vm extension set --resource-group "$resourceGroup" --vm-name "$dcVmName" --name CustomScriptExtension --publisher Microsoft.Compute --settings "$jsonFilePath" --no-wait
# az vm extension set --resource-group "$resourceGroup" --vm-name "$dcVmName" --name CustomScriptExtension --publisher Microsoft.Compute --settings @dc_settings.json --no-wait

echo "Configuring the VM as a Domain Controller"
az vm extension set --resource-group "$resourceGroup" --vm-name "$dcVmName" --name CustomScriptExtension --publisher Microsoft.Compute --settings "{ \"fileUris\": [\"$dcConfigScriptUri\"], \"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File install_ad_ds_and_forest.ps1\" }"


echo "Restart the domain controller VM"
az vm restart --resource-group "$resourceGroup" --name "$dcVmName"


echo "Creating Windows 10 Client VM"
az vm create --resource-group "$resourceGroup" --name "$tenVmName" --image "MicrosoftWindowsDesktop:Windows-10:20h2-pro:latest" --admin-username "$tenAdminUsername" --admin-password "$tenAdminPassword" --size "$vmSize" --nsg "$nsgName"

# Creating Windows 11 Client VM
# echo "Creating Windows 11 Client VM"
# az vm create --resource-group "$resourceGroup" --name "$elevenVmName" --image "MicrosoftWindowsDesktop:windows-11:win11-23h2-pro:latest" --admin-username "$elevenAdminUsername" --admin-password "$elevenAdminPassword" --size "$vmSize" --nsg "$nsgName"


echo "Creating IIS Server VM"
az vm create --resource-group "$resourceGroup" --name "$iisVmName" --image Win2019Datacenter --admin-username "$iisAdminUsername" --admin-password "$iisAdminPassword" --size "$vmSize" --nsg "$nsgName"


echo "Wait for the domain controller and WIndows VM to restart"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$dcVmName"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$tenVmName"
# az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$elevenVmName"
az vm wait --created --custom "instanceView.powerState.status=='VM running'" -g "$resourceGroup" --name "$iisVmName"

echo "Joining Windows 10 to Domain"
az vm extension set \
--publisher Microsoft.Compute \
--version 1.9 \
--name CustomScriptExtension \
--vm-name "$tenVmName" \
--resource-group $resourceGroup \
--settings "{\"fileUris\": [\"$vmConfigScriptUri\"]}" \
--protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File join-domain.ps1\"}"


echo "Adding USers on Windows 10 VM and granting them RDP Access"
# az vm extension set --publisher Microsoft.Compute --version 1.9 --name CustomScriptExtension --vm-name "$tenVmName" --resource-group $resourceGroup --settings "{\"fileUris\": [\"$vmAddUsersWithRDPUri\"]}" --protected-settings "{\"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File add_users_and_grant_rdp.ps1\"}"


echo "Joining Windows 11 to Domain"
# az vm extension set --resource-group "$resourceGroup" --vm-name "$elevenVmName" --name CustomScriptExtension --publisher Microsoft.Compute --settings "{ \"fileUris\": [\"$vmConfigScriptUri\"], \"commandToExecute\": \"powershell -ExecutionPolicy Unrestricted -File join-domain.ps1\" }"


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

echo "Restart the domain controller VM"
az vm restart --resource-group "$resourceGroup" --name "$iisVmName"

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

