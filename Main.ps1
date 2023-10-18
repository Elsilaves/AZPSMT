# Import scripts
. "$PSScriptRoot\Classes\AzureADManagement.ps1"
. "$PSScriptRoot\Modules\UtilityFunctions.ps1"
. "$PSScriptRoot\Modules\AzureADModuleManager.ps1"


# Define the main menu options
$menu = @(
    "1. Create a new Azure AD user",
    "2. Create a new Azure AD domain group",
    "3. Add a user to an Azure AD domain group",
    "4. Deploy a Windows VM in Azure",
    "5. Print Unix Epoch",
    "6. Get Fire Type Pokemons",
    "7. Exit"
)

$azureManagement = [AzureADManagement]::new()

# Main Menu loop to drive user actions
do {
    $menu | ForEach-Object { Write-Host $_ }
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' { $azureManagement.CreateUser() }
        '2'{ $azureManagement.CreateGroup() }
        '3' { $azureManagement.AddUserToGroup() }
        '4' { $azureManagement.DeployAndJoinVM() }
        '5' { PrintUnixEpoch }
        '6' { GetFireTypePokemons }
        '7' { exit }
        default { Write-Host "Invalid choice" }
    }

    $continue = Read-Host "Do you want to continue? (Y/N)"
} while ($continue -eq 'Y')