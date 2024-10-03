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
