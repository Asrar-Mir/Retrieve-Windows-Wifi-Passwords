$Host.UI.RawUI.ForegroundColor = "Red"
$asciiArt = @"
▄▄▄        ██████  ██▀███   ▄▄▄       ██▀███      ███▄ ▄███▓ ██▓ ██▀███  
▒████▄    ▒██    ▒ ▓██ ▒ ██▒▒████▄    ▓██ ▒ ██▒   ▓██▒▀█▀ ██▒▓██▒▓██ ▒ ██▒
▒██  ▀█▄  ░ ▓██▄   ▓██ ░▄█ ▒▒██  ▀█▄  ▓██ ░▄█ ▒   ▓██    ▓██░▒██▒▓██ ░▄█ ▒
░██▄▄▄▄██   ▒   ██▒▒██▀▀█▄  ░██▄▄▄▄██ ▒██▀▀█▄     ▒██    ▒██ ░██░▒██▀▀█▄  
 ▓█   ▓██▒▒██████▒▒░██▓ ▒██▒ ▓█   ▓██▒░██▓ ▒██▒   ▒██▒   ░██▒░██░░██▓ ▒██▒
 ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░   ░ ▒░   ░  ░░▓  ░ ▒▓ ░▒▓░
  ▒   ▒▒ ░░ ░▒  ░ ░  ░▒ ░ ▒░  ▒   ▒▒ ░  ░▒ ░ ▒░   ░  ░      ░ ▒ ░  ░▒ ░ ▒░
  ░   ▒   ░  ░  ░    ░░   ░   ░   ▒     ░░   ░    ░      ░    ▒ ░  ░░   ░ 
      ░  ░      ░     ░           ░  ░   ░               ░    ░     ░      
"@

Write-Host $asciiArt

$Host.UI.RawUI.ForegroundColor = "Green"

$WirelessSSIDs = (netsh wlan show profiles | Select-String 'All User Profile' | ForEach-Object { $_ -replace '.*:\s*', '' })

# Initialize arrays to hold the results
$WifiWithPassword = @()
$WifiWithoutPassword = @()

foreach($SSID in $WirelessSSIDs) {
    # Remove any escape characters
    $SSID = $SSID -replace '\\', '\'
    $Password = (netsh wlan show profiles name="$SSID" key=clear | Select-String 'Key Content') -replace '.*:\s*', ''

    # Check if Password is empty
    if ([string]::IsNullOrWhiteSpace($Password)) {
        $Password = $null
        $WifiWithoutPassword += [PSCustomObject]@{
            SSID     = $SSID
            Password = $Password
        }
    } else {
        $WifiWithPassword += [PSCustomObject]@{
            SSID     = $SSID
            Password = $Password
        }
    }
}

# Combine the results, with passwords first
$FinalResult = $WifiWithPassword + $WifiWithoutPassword
$FinalResult | ConvertTo-Json | ForEach-Object { $_ -replace '\\\\', '\' }
$Host.UI.RawUI.ForegroundColor = "White"

