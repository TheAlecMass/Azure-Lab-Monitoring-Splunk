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
