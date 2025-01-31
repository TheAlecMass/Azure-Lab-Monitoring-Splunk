# =============================================================================
# QUT Log Forwarder Private IP Update Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script retrieves the private IP address of the Azure Lab 
# environment and updates the QUT Log Forwarder script (`push-logs-to-SA.ps1`) 
# by replacing the placeholder IP address with the actual private IP.
#
# Functionality:
# - Retrieves the private IPv4 address of the machine, excluding loopback interfaces.
# - Checks if a valid IP address is found before proceeding.
# - Replaces the `priv_ip_address_placeholder` in the log forwarder script 
#   with the actual private IP.
# - Prevents overwriting if no valid IP address is found.
#
# Key Components:
# - `Get-NetIPAddress`: Fetches the machine's IPv4 address.
# - `Where-Object`: Filters out loopback and inactive addresses.
# - `Get-Content` / `Set-Content`: Reads and modifies the target script.
# - `Write-Warning`: Alerts the user if no valid IP address is found.
#
# Notes:
# - Ensure the script runs with administrative privileges.
# - The script modifies `push-logs-to-SA.ps1` in:  
#   `C:\Program Files\QUT-Log-Forwarder\Scheduler\`
# - PowerShell execution policy should be set to `RemoteSigned`.
# - The Azure Lab environment must be running to retrieve a valid IP address.
#
# =============================================================================

# PowerShell script to fetch the Azure lab private IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "Loopback*" -and $_.AddressState -eq "Preferred"}).IPAddress
$schedulerPath = "C:\Program Files\QUT-Log-Forwarder\Scheduler"
$scriptfile = "$schedulerPath\push-logs-to-SA.ps1"

# Ensure that the IP address is not null or empty before attempting to replace
if (![string]::IsNullOrWhiteSpace($ipAddress)) {
    # Use a regex to replace the placeholder or existing IP address with the new IP address
    (Get-Content $scriptfile) -replace 'priv_ip_address_placeholder', $ipAddress | Set-Content $scriptfile
} else {
    Write-Warning 'No valid private IP address found.'
}
