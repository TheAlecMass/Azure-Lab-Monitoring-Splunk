Set-ExecutionPolicy RemoteSigned -Scope Process -Force

$basePath = "C:\Program Files\QUT-Log-Forwarder\Logs"
$os = "Windows"
$pub_ip_address = "pub_ip_address_placeholder"
$priv_ip_address = "priv_ip_address_placeholder"
$logPath = "C:\Program Files\QUT-Log-Forwarder\Scheduler\log.txt"
$lockFile = "C:\Program Files\QUT-Log-Forwarder\Scheduler\script.lock"

# Logging function
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logPath -Append -Force
}

# Function to acquire a lock
function Acquire-Lock {
    param (
        [string]$lockFile
    )
    $lockHandle = New-Object System.IO.FileStream($lockFile, [System.IO.FileMode]::Create, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
    return $lockHandle
}

# Function to release a lock
function Release-Lock {
    param (
        [System.IO.FileStream]$lockHandle
    )
    $lockHandle.Close()
}

# Try to acquire the lock
try {
    $lockHandle = Acquire-Lock -lockFile $lockFile
} catch {
    Write-Log "Another instance of the script is already running. Exiting."
    exit
}

Write-Log "Script started"

# Define file paths for logs and archives
$logFiles = @{
    CPU = "$basePath\win-logs-CPU_$priv_ip_address.log"
    Memory = "$basePath\win-logs-Memory_$priv_ip_address.log"
    Disk = "$basePath\win-logs-Disk_$priv_ip_address.log"
    System = "$basePath\win-logs-System_$priv_ip_address.log"
    Network = "$basePath\win-logs-Network_$priv_ip_address.log"
}
$archiveFiles = @{
    CPU = "$basePath\win-logs-CPU_ARCHIVE_$priv_ip_address.log"
    Memory = "$basePath\win-logs-Memory_ARCHIVE_$priv_ip_address.log"
    Disk = "$basePath\win-logs-Disk_ARCHIVE_$priv_ip_address.log"
    System = "$basePath\win-logs-System_ARCHIVE_$priv_ip_address.log"
    Network = "$basePath\win-logs-Network_ARCHIVE_$priv_ip_address.log"
}

# Function to get the current local time
function Get-LocalTime {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss.fff K")
}

# Function to clean up counter name
function Clean-CounterName {
    param (
        [string]$counterName
    )
    $cleanName = $counterName -replace "^(\\\\[^\\]+\\[^\\]+\\)", ""
    return $cleanName -replace "[^a-zA-Z0-9]", ""
}

# Function to log data to console and files for debugging
function Log-Data {
    param (
        [string]$filePath,
        [string]$archivePath,
        [array]$data
    )

    $data | ForEach-Object { 
        $cleanCounterName = Clean-CounterName -counterName $_.CounterName
        if ($_.source -eq "syslog") {
            $logEntry = "source=$($_.source)`ncounter=syslog`nos=$($_.OS)`npriv_ip_address=$($_.priv_ip_address)`npub_ip_address=$($_.pub_ip_address)`nsyslog-Value=$($_.Value)`n"
        } elseif ($_.source -eq "WIN:Perfmon:Network" -or $_.source -eq "WIN:Perfmon:Memory" -or $_.source -eq "WIN:Perfmon:System") {
            $logEntry = "source=$($_.source)`ncounter=$cleanCounterName`nos=$($_.OS)`npriv_ip_address=$($_.priv_ip_address)`npub_ip_address=$($_.pub_ip_address)`n$cleanCounterName-Value=$($_.Value)`n"
        } else {
            $logEntry = "source=$($_.source)`ncounter=$cleanCounterName`n$cleanCounterName-instance=$($_.InstanceName)`nos=$($_.OS)`npriv_ip_address=$($_.priv_ip_address)`npub_ip_address=$($_.pub_ip_address)`n$cleanCounterName-$($_.InstanceName)-Value=$($_.Value)`n"
        }
        $logEntry += "`n//`n"
        $logEntry | Out-File -FilePath $archivePath -Append -Force
        $logEntry | Out-File -FilePath $filePath -Append -Force
        Write-Host $logEntry
    }
}

# Function to collect CPU performance data
function Get-CPUData {
    Write-Log "Collecting CPU data"
    $cpuData = Get-Counter -Counter "\Processor(*)\% Processor Time", "\Processor(*)\% User Time", "\Processor(*)\% Privileged Time"
    $timestamp = Get-LocalTime
    $data = $cpuData.CounterSamples | ForEach-Object {
        @{
            source = "WIN:Perfmon:CPU"
            OS = $os
            priv_ip_address = $priv_ip_address
            pub_ip_address = $pub_ip_address
            CounterName = $_.Path
            InstanceName = $_.InstanceName
            Value = $_.CookedValue
        }
    }
    return $data
}

# Function to collect Memory performance data
function Get-MemoryData {
    Write-Log "Collecting Memory data"
    $memoryData = Get-Counter -Counter "\Memory\Available MBytes", "\Memory\% Committed Bytes In Use"
    $timestamp = Get-LocalTime
    $data = $memoryData.CounterSamples | ForEach-Object {
        @{
            source = "WIN:Perfmon:Memory"
            OS = $os
            priv_ip_address = $priv_ip_address
            pub_ip_address = $pub_ip_address
            CounterName = $_.Path
            Value = $_.CookedValue
        }
    }
    return $data
}

# Function to collect Disk performance data
function Get-DiskData {
    Write-Log "Collecting Disk data"
    $diskData = Get-Counter -Counter "\LogicalDisk(*)\% Free Space", "\LogicalDisk(*)\Free Megabytes", "\LogicalDisk(*)\% Disk Time", "\LogicalDisk(*)\Disk Reads/sec", "\LogicalDisk(*)\Disk Writes/sec"
    $timestamp = Get-LocalTime
    $data = $diskData.CounterSamples | ForEach-Object {
        @{
            source = "WIN:Perfmon:Disk"
            OS = $os
            priv_ip_address = $priv_ip_address
            pub_ip_address = $pub_ip_address
            CounterName = $_.Path
            InstanceName = $_.InstanceName
            Value = $_.CookedValue
        }
    }
    return $data
}

# Function to collect System performance data
function Get-SystemData {
    Write-Log "Collecting System data"
    $systemData = Get-Counter -Counter "\System\System Up Time"
    $timestamp = Get-LocalTime
    $data = $systemData.CounterSamples | ForEach-Object {
        @{
            source = "WIN:Perfmon:System"
            OS = $os
            priv_ip_address = $priv_ip_address
            pub_ip_address = $pub_ip_address
            CounterName = $_.Path
            Value = $_.CookedValue
        }
    }
    return $data
}

# Function to collect Network performance data
function Get-NetworkData {
    Write-Log "Collecting Network data"
    $networkData = Get-Counter -Counter "\Network Interface(*)\Bytes Total/sec", "\Network Interface(*)\Bytes Sent/sec", "\Network Interface(*)\Bytes Received/sec", "\Network Interface(*)\Packets/sec", "\Network Interface(*)\Packets Sent/sec", "\Network Interface(*)\Packets Received/sec"
    $timestamp = Get-LocalTime
    $data = $networkData.CounterSamples | ForEach-Object {
        @{
            source = "WIN:Perfmon:Network"
            OS = $os
            priv_ip_address = $priv_ip_address
            pub_ip_address = $pub_ip_address
            CounterName = $_.Path
            InstanceName = $_.InstanceName
            Value = $_.CookedValue
        }
    }
    return $data
}

# Collect and log performance data
$cpuData = Get-CPUData
$memoryData = Get-MemoryData
$diskData = Get-DiskData
$systemData = Get-SystemData
$networkData = Get-NetworkData

# Clear the log files before writing new data
Clear-Content -Path $logFiles.CPU
Clear-Content -Path $logFiles.Memory
Clear-Content -Path $logFiles.Disk
Clear-Content -Path $logFiles.System
Clear-Content -Path $logFiles.Network

# Log data to archive files and latest log files
Log-Data -filePath $logFiles.CPU -archivePath $archiveFiles.CPU -data $cpuData
Log-Data -filePath $logFiles.Memory -archivePath $archiveFiles.Memory -data $memoryData
Log-Data -filePath $logFiles.Disk -archivePath $archiveFiles.Disk -data $diskData
Log-Data -filePath $logFiles.System -archivePath $archiveFiles.System -data $systemData
Log-Data -filePath $logFiles.Network -archivePath $archiveFiles.Network -data $networkData

# Azure Storage upload configuration
$storageAccountUrl = "SAS_token_placeholder"

# Run AzCopy to upload the latest log files to Azure Storage
foreach ($logFile in $logFiles.GetEnumerator()) {
    Write-Log "Uploading $($logFile.Value) to Azure Storage"
    & "C:\Program Files\QUT-Log-Forwarder\Scheduler\azcopy.exe" copy $logFile.Value $storageAccountUrl
}

Write-Log "Logs uploaded to Azure Storage."
Write-Log "Script finished"

# Release the lock
Release-Lock -lockHandle $lockHandle
