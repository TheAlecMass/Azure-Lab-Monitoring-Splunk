# =============================================================================
# QUT Log Forwarder SAS Token Update Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script updates the Azure Storage Account SAS Token 
# in the QUT Log Forwarder script by replacing a placeholder with the 
# user-provided SAS token. This ensures that the script can authenticate 
# correctly when uploading logs to Azure Storage.
#
# Functionality:
# - Prompts the user to enter the Azure SAS Token.
# - Checks if the `push-logs-to-SA.ps1` script exists.
# - Reads the file and replaces the `SAS_token_placeholder` with the provided token.
# - Saves the updated script with the new SAS token.
# - Provides confirmation upon successful update.
#
# Key Components:
# - `Read-Host`: Prompts the user for input.
# - `Test-Path`: Verifies the existence of the target script.
# - `Get-Content` / `Set-Content`: Reads and updates the file contents.
# - String replacement to update the SAS token in the script.
#
# Notes:
# - The script must be executed with administrative privileges.
# - Ensure that the provided SAS token has the correct permissions for 
#   Azure Storage access.
# - The script modifies `push-logs-to-SA.ps1` located in:  
#   `C:\Program Files\QUT-Log-Forwarder\Scheduler\`
# - PowerShell execution policy should be set to `RemoteSigned`.
#
# =============================================================================

 
 # Prompt the user for the Azure Storage Account SAS Token
$SASToken = Read-Host -Prompt "Please enter your Azure Storage Account SAS Token"

# Define the path to the file
$filePath = "C:\Program Files\QUT-Log-Forwarder\Scheduler\push-logs-to-SA.ps1"

# Check if the file exists
if (-Not (Test-Path $filePath)) {
    Write-Host "File not found: $filePath"
    exit 1
}

# Read the file content
$fileContent = Get-Content -Path $filePath

# Replace the placeholder with the provided SAS Token
$fileContent = $fileContent -replace "SAS_token_placeholder", $SASToken

# Write the updated content back to the file
Set-Content -Path $filePath -Value $fileContent

Write-Host "SAS Token has been successfully updated in the file."
