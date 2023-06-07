# Add user to Administrators group
Add-LocalGroupMember -Group "Administrators" -Member "localadmin"


# Add user to PreventAdmin group
New-LocalGroup -Name "PreventAdmin" -Description "PreventAdmin group"

# Add User3 and User4 to PreventAdmin group
Add-LocalGroupMember -Group "PreventAdmin" -Member "User3"
Add-LocalGroupMember -Group "PreventAdmin" -Member "User4"
