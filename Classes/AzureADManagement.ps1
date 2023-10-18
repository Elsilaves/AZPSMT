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

}
