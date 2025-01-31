# =============================================================================
# QUT Log Forwarder AzCopy Installation Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script automates the installation of AzCopy, a command-line 
# utility for transferring files to and from Azure Storage. It ensures that 
# AzCopy is properly downloaded, extracted, and placed in the correct directory 
# for use in the QUT Log Forwarder system.
#
# Functionality:
# - Creates the installation directory if it does not exist.
# - Downloads the latest AzCopy zip file from Microsoft's official URL.
# - Extracts the contents of the zip file.
# - Locates the `azcopy.exe` executable and moves it to the installation directory.
# - Cleans up unnecessary files after installation.
# - Provides status messages to indicate progress and success.
#
# Key Components:
# - `$installPath`: Defines where AzCopy will be installed.
# - `Invoke-WebRequest`: Downloads the AzCopy zip file.
# - `Expand-Archive`: Extracts the downloaded zip file.
# - `Move-Item`: Moves the AzCopy executable to the final install location.
# - `Remove-Item`: Cleans up temporary files after installation.
#
# Notes:
# - The script must be executed with administrative privileges.
# - The AzCopy download URL (`https://aka.ms/downloadazcopy-v10-windows`) 
#   should be accessible.
# - PowerShell execution policy should be set to `RemoteSigned`.
# - Ensure there is internet access to download the AzCopy installer.
#
# =============================================================================
 
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
