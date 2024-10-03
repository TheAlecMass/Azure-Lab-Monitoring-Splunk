# PowerShell script to fetch the public IP address
$ipAddress = Invoke-RestMethod -Uri 'http://ipinfo.io/ip' -Method Get
$schedulerPath = "C:\Program Files\QUT-Log-Forwarder\Scheduler"
$scriptfile = "$schedulerPath\push-logs-to-SA.ps1"

# Replace the placeholder with the fetched public IP address
(Get-Content $scriptfile) -replace 'pub_ip_address_placeholder', $ipAddress | Set-Content $scriptfile
# Command to start the SplunkForwarder service

