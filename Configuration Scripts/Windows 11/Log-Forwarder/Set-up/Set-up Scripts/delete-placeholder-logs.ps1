# =============================================================================
# QUT Delete Placeholders Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script removes log files containing placeholder IP addresses 
# from the QUT Log Forwarder directory. It ensures that logs with 
# `_priv_ip_address_placeholder` in their filenames are deleted before new logs 
# are generated.
#
# Functionality:
# - Identifies log files in the designated log directory.
# - Searches for files containing `_priv_ip_address_placeholder` in their names.
# - Deletes each identified placeholder file to prevent incorrect log storage.
# - Outputs confirmation messages for deleted files.
#
# Key Components:
# - `$logDirectory`: Specifies the path to the log storage location.
# - `Get-ChildItem`: Retrieves log files matching the placeholder pattern.
# - `Remove-Item`: Deletes the identified placeholder files.
# - `Write-Host`: Displays messages indicating file deletions.
#
# Notes:
# - Ensure the log directory exists at `C:\Program Files\QUT-Log-Forwarder\Logs`.
# - This script should be executed before log collection to avoid conflicts.
# - Requires administrative privileges for file deletion.
#
# =============================================================================

 
 # Define the log directory
$logDirectory = "C:\Program Files\QUT-Log-Forwarder\Logs"

# Get all files with _ip_placeholder in their name
$placeholderFiles = Get-ChildItem -Path $logDirectory -Filter "*_priv_ip_address_placeholder*"

# Delete each placeholder file
foreach ($file in $placeholderFiles) {
    Remove-Item -Path $file.FullName -Force
    Write-Host "Deleted file: $($file.FullName)"
}
