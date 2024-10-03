# Define the path to the directory
$directoryPath = "C:\Program Files\QUT-Log-Forwarder\Set-up\Set-up Scripts"

# Check if the directory exists
if (-Not (Test-Path $directoryPath)) {
    Write-Host "Directory not found: $directoryPath"
    exit 1
}

# Function to prompt user to press space to continue
function Wait-ForSpace {
    Write-Host "Press SPACE to continue..."
    do {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } while ($key.Character -ne ' ')
    Write-Host "`n`n"
}

# Navigate to the directory
Set-Location -Path $directoryPath

# Run the commands sequentially with confirmation prompts
try {
    & .\get-SAS-AccessToken
    Write-Host "get-SAS-AccessToken executed successfully."
    Wait-ForSpace
    
    & .\get-azcopy
    Write-Host "get-azcopy executed successfully."
    Wait-ForSpace
    
    Write-Host "Generating scheduled tasks..."
    & .\set-taskschedulerAndAccessPerms
    Write-Host "set-taskscheduler executed successfully."
    Wait-ForSpace

    & .\get-Forwarder-QA
    Wait-ForSpace
} catch {
    Write-Host "An error occurred while executing one of the commands: $_"
}

# Navigate back to the original location (optional)
Set-Location -Path $PSScriptRoot
