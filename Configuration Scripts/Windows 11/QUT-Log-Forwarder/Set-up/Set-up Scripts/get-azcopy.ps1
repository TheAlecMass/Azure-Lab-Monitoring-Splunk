# Define the installation path
$installPath = "C:\Program Files\QUT-Log-Forwarder\Scheduler"
$azCopyUrl = "https://aka.ms/downloadazcopy-v10-windows"

# Create the installation directory if it doesn't exist
if (-Not (Test-Path -Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath -Force
}

# Define the path for the downloaded zip file and the extracted directory
$zipPath = "$installPath\azcopy.zip"
$extractPath = "$installPath\azcopy"

# Download AzCopy zip file
Write-Host "Downloading AzCopy from $azCopyUrl..."
Invoke-WebRequest -Uri $azCopyUrl -OutFile $zipPath

# Extract the zip file
Write-Host "Extracting AzCopy..."
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Find the AzCopy executable and move it to the install path
$azCopyExe = Get-ChildItem -Path $extractPath -Filter "azcopy.exe" -Recurse | Select-Object -First 1

if ($azCopyExe) {
    Move-Item -Path $azCopyExe.FullName -Destination $installPath -Force
    Write-Host "AzCopy installed successfully at $installPath"
} else {
    Write-Host "AzCopy executable not found in the extracted files."
}

# Clean up
Write-Host "Cleaning up..."
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force

Write-Host "Installation complete."
