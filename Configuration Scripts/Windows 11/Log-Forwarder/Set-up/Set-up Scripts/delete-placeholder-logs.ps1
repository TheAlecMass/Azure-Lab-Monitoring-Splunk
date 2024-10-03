# Define the log directory
$logDirectory = "C:\Program Files\QUT-Log-Forwarder\Logs"

# Get all files with _ip_placeholder in their name
$placeholderFiles = Get-ChildItem -Path $logDirectory -Filter "*_priv_ip_address_placeholder*"

# Delete each placeholder file
foreach ($file in $placeholderFiles) {
    Remove-Item -Path $file.FullName -Force
    Write-Host "Deleted file: $($file.FullName)"
}
