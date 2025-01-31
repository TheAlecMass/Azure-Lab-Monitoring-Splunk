# =============================================================================
# QUT Log Forwarder Setup Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script automates the setup process for the QUT Log Forwarder.
# It ensures that necessary dependencies and scheduled tasks are configured
# before running the main log collection script.
#
# Functionality:
# - Checks for the presence of the required setup directory.
# - Runs setup scripts sequentially to configure:
#   - SAS Token retrieval for Azure Storage access.
#   - AzCopy installation for log uploads.
#   - Task Scheduler setup to automate log collection.
#   - Forwarder setup for Quality Assurance (QA) testing.
# - Includes user prompts to confirm execution at each step.
# - Implements basic error handling for failed script execution.
#
# Key Components:
# - Execution of setup scripts:
#   - `get-SAS-AccessToken`: Retrieves Azure SAS token for log uploads.
#   - `get-azcopy`: Installs AzCopy for Azure Storage transfers.
#   - `set-taskschedulerAndAccessPerms`: Configures Task Scheduler.
#   - `get-Forwarder-QA`: Runs QA setup for the log forwarder.
#
# Notes:
# - Ensure that the setup directory exists: `C:\Program Files\QUT-Log-Forwarder\Set-up\Set-up Scripts`
# - The script must be executed with administrative privileges.
# - PowerShell execution policy should be set to `RemoteSigned`.
#
# =============================================================================

 
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
