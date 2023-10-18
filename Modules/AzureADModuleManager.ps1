# Check if AzureAD module is imported
if (-not (Get-Module -Name AzureAD)) {
    try {
        Import-Module AzureAD
    } catch {
        Write-Host "Error importing AzureAD module. Please ensure it's installed."
        return
    }
}

# Determine if connected to AzureAD
$connected = $false

try {
    $tenantInfo = Get-AzureADTenantDetail -ErrorAction SilentlyContinue
    if ($tenantInfo) {
        $connected = $true
        Write-Host "Already connected to AzureAD."
    }
} catch {
    $connected = $false
}

# If not connected, prompt for credentials and connect
if (-not $connected) {
    try {
        Connect-AzureAD -ErrorAction SilentlyContinue
        Write-Host "Connected to AzureAD."
    } catch {
        Write-Host "Error connecting to AzureAD. Please ensure you have correct permissions or that you are running the script with sufficient privileges."
        return
    }
}
