class AzureADManagement {

    # Method to create a new Azure AD user
    [void] CreateUser() {
        $userName = Read-Host "Enter username for the new Azure AD domain user"
        $displayName = Read-Host "Enter display name for the new Azure AD domain user"

        # Prompt user to enable or disable the account
        $accountEnabledResponse = Read-Host "Do you want to enable the account? (Y/N)"
        $accountEnabled = $accountEnabledResponse -eq 'Y'

        # Generate random password
        $password = GenerateRandomPassword
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        $mailNickName = $userName.Split("@")[0]

        Write-Host "Creating Azure AD domain user..."
    
        try {
            New-AzureADUser -DisplayName $displayName -PasswordProfile (New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile -Property @{ForceChangePasswordNextLogin = $false; Password = $password}) -UserPrincipalName $userName -MailNickName $mailNickName -AccountEnabled $accountEnabled

            Write-Host "User created. Password is: $password" -ForegroundColor Green
        } catch {
            if ($_ -like "*Another object with the same value for property userPrincipalName already exists.*") {
                Write-Host "A user with the username $userName already exists." -ForegroundColor Red
            } else {
                Write-Host "Error creating user: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

     # Method to add a user to a group in Azure AD
     [void] AddUserToGroup() {
        $userUPN = Read-Host "Enter the User Principal Name (UPN) of the user"
        $groupName = Read-Host "Enter the name of the group"

        # Check if the user exists
        try {
            $user = Get-AzureADUser -ObjectId $userUPN
        } catch {
            if ($_.Exception.Message -like "*Request_ResourceNotFound*") {
                Write-Host "User $userUPN does not exist in Azure AD." -ForegroundColor Red
                return
            } else {
                Write-Host "An error occurred while retrieving the user: $($_.Exception.Message)" -ForegroundColor Red
                return
            }
        }

        # Check if the group exists
        $groups = @()
        try {
            $groups = Get-AzureADGroup -SearchString $groupName
        } catch {
            if ($_.Exception.Message -like "*Request_ResourceNotFound*") {
                Write-Host "Group $groupName does not exist in Azure AD." -ForegroundColor Red
                return
            } else {
                Write-Host "An error occurred while searching for the group: $($_.Exception.Message)" -ForegroundColor Red
                return
            }
        }

        if ($groups.Count -eq 0) {
            Write-Host "Group $groupName does not exist in Azure AD." -ForegroundColor Red
            return
        } elseif ($groups.Count -gt 1) {
            Write-Host "Multiple groups found matching the name $groupName." -ForegroundColor Yellow
            foreach ($grp in $groups) {
                Write-Host "Group Name: $($grp.DisplayName), Object ID: $($grp.ObjectId)"
            }
            $groupObjectId = Read-Host "Please enter the Object ID of the desired group"
            $group = $groups | Where-Object { $_.ObjectId -eq $groupObjectId }
            if (-not $group) {
                Write-Host "Invalid Object ID provided. Exiting..." -ForegroundColor Red
                return
            }
        } else {
            $group = $groups[0]
        }

        # Check if the user is already a member of the group
        $groupMembers = Get-AzureADGroupMember -ObjectId $group.ObjectId
        if ($groupMembers.ObjectId -contains $user.ObjectId) {
            Write-Host "User $userUPN is already a member of the group $groupName." -ForegroundColor Yellow
            return
        }

        # Add user to the group
        try {
            Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $user.ObjectId
            Write-Host "User $userUPN added to group $groupName successfully." -ForegroundColor Green
        } catch {
            Write-Host "An error occurred while adding the user to the group: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

}
