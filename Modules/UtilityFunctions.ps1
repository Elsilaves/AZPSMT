# Function to fetch all verified domains
function Get-VerifiedDomains {
    return (Get-AzureADDomain | Where-Object { $_.IsVerified -eq $true }).Name
}

# Function to generate a random password
function GenerateRandomPassword {
    $lowercase = [char[]] (97..122) 
    $uppercase = [char[]] (65..90)  
    $digits = [char[]] (48..57)     
    $specialChars = [char[]] '!@#$%^&*_-+='
    $allChars = $lowercase + $uppercase + $digits + $specialChars
    return (-join ($allChars | Get-Random -Count 12))
}

function PrintUnixEpoch {
    # ... (your existing PrintUnixEpoch function code here) ...
}

function GetFireTypePokemons {
    # ... (your existing GetFireTypePokemons function code here) ...
}
