# Define the paths and filenames
$filePath = "C:\Program Files\QUT-Log-Forwarder\Scheduler\push-logs-to-SA.ps1"
$azCopyPath = "C:\Program Files\QUT-Log-Forwarder\Scheduler\azcopy.exe"
$UploadSyslog = "UploadSyslog"
$ReplacePrivIP = "ReplacePrivIP"
$ReplacePubIP = "ReplacePubIP"
$DeletePlaceholderLogs = "DeletePlaceholderLogs"
$directoryPath = "C:\Program Files\QUT-Log-Forwarder"

# Initialize success flag
$success = $true

# Function to extract values using regex pattern
function Extract-Value {
    param (
        [string]$content,
        [string]$pattern
    )
    $match = $content | Select-String -Pattern $pattern
    if ($match) {
        return $match.Matches.Groups[1].Value
    }
    return $null
}

# Read the script content
$scriptContent = Get-Content -Path $filePath -Raw

# Extract private IP, public IP, and SAS token
$privateIP = Extract-Value -content $scriptContent -pattern '\$priv_ip_address\s*=\s*"([^"]+)"'
$publicIP = Extract-Value -content $scriptContent -pattern '\$pub_ip_address\s*=\s*"([^"]+)"'
$sasToken = Extract-Value -content $scriptContent -pattern '\$storageAccountUrl\s*=\s*"([^"]+)"'

# Display the extracted values
Write-Host "QA Results:"
Write-Host ""
if ($sasToken) {
    Write-Host "SAS token: $sasToken"
} else {
    Write-Host "SAS token not found or invalid."
    $success = $false
}
Write-Host ""
Write-Host "Please ensure that the Azure SAS Token has appropriate access permissions to the storage account."
Write-Host ""

# Check if azcopy is located in the specified directory
if (Test-Path $azCopyPath) {
    Write-Host "azcopy located at: $azCopyPath"
} else {
    Write-Host "azcopy not found in the specified directory."
    $success = $false
}
Write-Host ""

# Check if the task scheduler exists
$task1 = Get-ScheduledTask -TaskName $UploadSyslog -ErrorAction SilentlyContinue
$task2 = Get-ScheduledTask -TaskName $ReplacePrivIP -ErrorAction SilentlyContinue
$task3 = Get-ScheduledTask -TaskName $ReplacePubIP -ErrorAction SilentlyContinue
$task4 = Get-ScheduledTask -TaskName $DeletePlaceholderLogs -ErrorAction SilentlyContinue

if ($task1) {
    Write-Host "Task scheduler '$UploadSyslog' exists."
} else {
    Write-Host "Task scheduler '$UploadSyslog' does not exist."
    $success = $false
}
if ($task2) {
    Write-Host "Task scheduler '$ReplacePrivIP' exists."
} else {
    Write-Host "Task scheduler '$ReplacePrivIP' does not exist."
    $success = $false
}
if ($task3) {
    Write-Host "Task scheduler '$ReplacePubIP' exists."
} else {
    Write-Host "Task scheduler '$ReplacePubIP' does not exist."
    $success = $false
}
if ($task4) {
    Write-Host "Task scheduler '$DeletePlaceholderLogs' exists."
} else {
    Write-Host "Task scheduler '$DeletePlaceholderLogs' does not exist."
    $success = $false
}
Write-Host ""

# Check directory permissions to ensure only DBS-Admin has access
$acl = Get-Acl -Path $directoryPath
$permissions = $acl.Access | Where-Object { $_.IdentityReference -match '\\DBS-Admin$' }
$allUsers = $acl.Access | Select-Object -ExpandProperty IdentityReference

if ($permissions) {
    if ($allUsers.Count -eq 1 -and ($allUsers -match '\\DBS-Admin$')) {
        Write-Host "Directory '$directoryPath' permissions are correctly set for only DBS-Admin."
    } else {
        Write-Host "Directory '$directoryPath' is accessible by other users besides DBS-Admin."
        $success = $false
    }
} else {
    Write-Host "Directory '$directoryPath' permissions are not correctly set for DBS-Admin."
    $success = $false
}
Write-Host ""

# Final output based on the success flag
if ($success) {
    Write-Host "QUT Log Forwarder Successfully Configured"
} else {
    Write-Host "ERROR: QUT Log Forwarder NOT configured correctly"
}
Write-Host ""
Write-Host "QA Complete"
