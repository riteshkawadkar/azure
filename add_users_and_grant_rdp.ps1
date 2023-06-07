# Add users
New-LocalUser -Name "User1" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User One" -Description "User One account"
New-LocalUser -Name "User2" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User Two" -Description "User Two account"
New-LocalUser -Name "User3" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User Three" -Description "User Three account"
New-LocalUser -Name "User4" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User Four" -Description "User Four account"
New-LocalUser -Name "localadmin" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "Local Admin" -Description "Local Admin account"


# Grant RDP access
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "User1"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "User2"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "User3"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "User4"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "localadmin"



# Add user to Administrators group
Add-LocalGroupMember -Group "Administrators" -Member "localadmin"

# Add user to PreventAdmin group
New-LocalGroup -Name "PreventAdmin" -Description "PreventAdmin group"

# Add User3 and User4 to PreventAdmin group
Add-LocalGroupMember -Group "PreventAdmin" -Member "User3"
Add-LocalGroupMember -Group "PreventAdmin" -Member "User4"
