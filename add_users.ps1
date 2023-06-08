$groupNames = "LabUsers", "ITUsers", "HODUsers"

foreach ($groupName in $groupNames) {
    New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Security
}

$password = ConvertTo-SecureString "NewMinal@123" -AsPlainText -Force

foreach ($groupName in $groupNames) {
    for ($i = 1; $i -le 2; $i++) {
        $username = "$($groupName)_User$i"
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
