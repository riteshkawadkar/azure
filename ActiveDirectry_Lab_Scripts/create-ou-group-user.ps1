# This script performs three tasks:
# 1. Creating Organizational Units (OUs) from a CSV file
# 2. Creating Groups from a CSV file
# 3. Creating Users from a CSV file

# Task 1: Creating Organizational Units (OUs)
# Import Active Directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from ous.csv in the $ADOU variable. CSV template needs the following headers -> name, path
$ADOUUrl = 'https://github.com/riteshkawadkar/azure/raw/main/ActiveDirectry_Lab_Scripts/ous.csv'
$ADOU = Import-Csv $ADOUUrl

# Loop through each row containing OU details in the CSV file
foreach ($ou in $ADOU)
{
    # Read data from each field in each row and assign the data to a variable
    $name = $ou.name
    $path = $ou.path

    # Create an Organizational Unit in the specified path
    New-ADOrganizationalUnit -Name $name -Path $path
} 

# Add a wait condition between tasks
Start-Sleep -Seconds 10

# Task 2: Creating Groups

# Import CSV containing group details
$groupsUrl = 'https://github.com/riteshkawadkar/azure/raw/main/ActiveDirectry_Lab_Scripts/groups.csv'
$groups = Import-Csv $groupsUrl

# Loop through the CSV to create groups
foreach ($group in $groups) {
    $groupProps = @{
        Name          = $group.name
        Path          = $group.path
        GroupScope    = $group.scope
        GroupCategory = $group.category
        Description   = $group.description
    }

    New-ADGroup @groupProps
}

# Add a wait condition between tasks
Start-Sleep -Seconds 10

# Task 3: Creating Users

# Store the data from users.csv in the $Users variable
$usersUrl = 'https://github.com/riteshkawadkar/azure/raw/main/ActiveDirectry_Lab_Scripts/groups.csv'
$Users = Import-Csv $usersUrl

# Loop through each row containing user details in the CSV file 
foreach ($User in $Users) {
    $Username = $User.SamAccountName

    # Check if the user already exists in AD
    if (Get-ADUser -Filter {SamAccountName -eq $Username}) {
        Write-Warning "A user account with username $Username already exists in Active Directory."
    }
    else {
        # User does not exist, proceed to create the new user account
        $userProps = @{
            SamAccountName             = $User.SamAccountName                   
            Path                       = $User.Path      
            GivenName                  = $User.GivenName 
            Surname                    = $User.Surname
            Initials                   = $User.Initials
            Name                       = $User.Name
            DisplayName                = $User.DisplayName
            UserPrincipalName          = $User.UserPrincipalName 
            Department                 = $User.Department
            Description                = $User.Description
            Office                     = $User.Office
            OfficePhone                = $User.OfficePhone
            StreetAddress              = $User.StreetAddress
            POBox                      = $User.POBox
            City                       = $User.City
            State                      = $User.State
            PostalCode                 = $User.PostalCode
            Title                      = $User.Title
            Company                    = $User.Company
            Country                    = $User.Country
            EmailAddress               = $User.Email
            AccountPassword            = (ConvertTo-SecureString $User.Password -AsPlainText -Force) 
            Enabled                    = $true
            ChangePasswordAtLogon      = $true
        }

        New-ADUser @userProps
    }
}

# End of script
