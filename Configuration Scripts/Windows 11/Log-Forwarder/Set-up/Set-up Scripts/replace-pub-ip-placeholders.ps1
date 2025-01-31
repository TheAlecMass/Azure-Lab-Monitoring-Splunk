# =============================================================================
# QUT Log Forwarder Public IP Update Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script retrieves the public IP address of the system 
# and updates the QUT Log Forwarder script (`push-logs-to-SA.ps1`) by 
# replacing the placeholder public IP with the actual public IP.
#
# Functionality:
# - Retrieves the public IP address using an external web service (`ipinfo.io`).
# - Replaces the `pub_ip_address_placeholder` in the log forwarder script 
#   with the actual public IP.
# - Ensures the QUT Log Forwarder is correctly configured with a real 
#   public IP before execution.
#
# Key Components:
# - `Invoke-RestMethod`: Fetches the current public IP from `ipinfo.io`.
# - `Get-Content` / `Set-Content`: Reads and updates the target script.
# - Ensures seamless integration with the log forwarding process.
#
# Notes:
# - The script requires internet access to fetch the public IP.
# - The script modifies `push-logs-to-SA.ps1` in:  
#   `C:\Program Files\QUT-Log-Forwarder\Scheduler\`
# - PowerShell execution policy should be set to `RemoteSigned`.
# - Administrative privileges may be required to modify the target script.
#
# =============================================================================


# PowerShell script to fetch the public IP address
$ipAddress = Invoke-RestMethod -Uri 'http://ipinfo.io/ip' -Method Get
$schedulerPath = "C:\Program Files\QUT-Log-Forwarder\Scheduler"
$scriptfile = "$schedulerPath\push-logs-to-SA.ps1"

# Replace the placeholder with the fetched public IP address
(Get-Content $scriptfile) -replace 'pub_ip_address_placeholder', $ipAddress | Set-Content $scriptfile
# Command to start the SplunkForwarder service

