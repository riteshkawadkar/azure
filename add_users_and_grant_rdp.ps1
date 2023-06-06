# Add users
New-LocalUser -Name "User1" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User One" -Description "User One account"
New-LocalUser -Name "User2" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User Two" -Description "User Two account"
New-LocalUser -Name "localadmin" -Password (ConvertTo-SecureString "123456" -AsPlainText -Force) -FullName "User Three" -Description "User Three account"

# Grant RDP access
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "User1"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "User2"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "localadmin"
