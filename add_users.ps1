Set-ExecutionPolicy RemoteSigned

Install-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory

# Create the OU
$ouName = "PreventAdmins"
$ouPath = "OU=PreventAdmins,DC=test,DC=local"

New-ADOrganizationalUnit -Name $ouName -Path $ouPath

# Create the computers
$computerNames = "lab1", "lab2", "lab3"
$computerOU = "OU=PreventAdmins,DC=test,DC=local"

foreach ($computerName in $computerNames) {
    $computerDN = "CN=$computerName,$computerOU"
    $password = ConvertTo-SecureString -String "NewMinal@123" -AsPlainText -Force
    
    New-ADComputer -Name $computerName -SamAccountName $computerName -Path $computerOU -Enabled $true -Description "Lab computer" -PasswordNeverExpires $true -PassThru |
        Set-ADAccountPassword -NewPassword $password |
        Enable-ADAccount
}

Write-Host "OU and computers created successfully."

$groupNames = "Lab", "IT", "HOD"

foreach ($groupName in $groupNames) {
    New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Security
}

$password = ConvertTo-SecureString -String "NewMinal@123" -AsPlainText -Force

foreach ($groupName in $groupNames) {
    for ($i = 1; $i -le 2; $i++) {
        $username = "$groupName" + "User$i"
        New-ADUser -Name $username -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $true
        Add-ADGroupMember -Identity $groupName -Members $username
    }
}

$rdpGroupName = "Remote Desktop Users"

foreach ($groupName in $groupNames) {
    $groupMembers = Get-ADGroupMember -Identity $groupName

    foreach ($user in $groupMembers) {
        Add-LocalGroupMember -Group $rdpGroupName -Member $user.SamAccountName
    }
}
