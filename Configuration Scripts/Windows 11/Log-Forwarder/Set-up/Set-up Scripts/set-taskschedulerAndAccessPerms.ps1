# =============================================================================
# QUT Log Forwarder Scheduled Task Setup Script
# Creation Date: 01/05/24
# Author: Alec Mass
#
# Version: 1
#
# Description:
# This PowerShell script configures file system permissions and sets up 
# scheduled tasks for the QUT Log Forwarder. It ensures secure access 
# to log files and automates key processes, such as log uploads and IP address 
# updates, using Windows Task Scheduler.
#
# Functionality:
# - Restricts folder permissions to `DBS-Admin` for security.
# - Creates and configures the following scheduled tasks:
#   - `UploadSyslog`: Runs `push-logs-to-SA.ps1` to upload logs to Azure.
#   - `ReplacePrivIP`: Updates private IP placeholders in log files.
#   - `ReplacePubIP`: Updates public IP placeholders in log files.
#   - `DeletePlaceholderLogs`: Removes outdated placeholder log files.
# - Ensures scheduled tasks run at system startup and every 5 minutes.
# - Removes any previously configured versions of the tasks before reinstallation.
#
# Key Components:
# - `Set-Acl`: Restricts folder permissions to `DBS-Admin`.
# - `New-ScheduledTaskTrigger`: Defines triggers for task execution.
# - `New-ScheduledTaskAction`: Specifies the scripts to execute.
# - `New-ScheduledTaskPrincipal`: Ensures tasks run with appropriate privileges.
# - `Register-ScheduledTask`: Registers and configures the scheduled tasks.
#
# Notes:
# - The script must be executed with administrative privileges.
# - PowerShell execution policy should be set to `RemoteSigned`.
# - The log forwarder directory must exist at `C:\Program Files\QUT-Log-Forwarder\`.
# - Scheduled tasks are configured to run with `DBS-Admin` user permissions.
#
# =============================================================================

 
# Define the folder path
$folderPath = "C:\Program Files\QUT-Log-Forwarder"

# Remove all existing permissions
$acl = Get-Acl $folderPath
$acl.SetAccessRuleProtection($True, $False) # Disable inheritance, remove inherited rules
$acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
Set-Acl -Path $folderPath -AclObject $acl

# Add DBS-Admin with full control permissions
$permission = "DBS-Admin", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
Set-Acl -Path $folderPath -AclObject $acl

# Create triggers
$taskTriggerStartup = New-ScheduledTaskTrigger -AtStartup
$taskTriggerRepetition = New-ScheduledTaskTrigger -Once -At ((Get-Date).Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Days 1)

# Remove old task if needed for Upload-Syslog
$oldtask = Get-ScheduledTask -TaskName "UploadSyslog" -ErrorAction SilentlyContinue

if ($oldtask -ne $null) {
    Unregister-ScheduledTask -TaskName "UploadSyslog" -Confirm:$false
}

# Create task action for UploadSyslog
$taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\QUT-Log-Forwarder\Scheduler\push-logs-to-SA.ps1"'

# The user to run the task
$taskUser = New-ScheduledTaskPrincipal -UserId 'DBS-Admin' -LogonType S4U -RunLevel Highest

# The name of the scheduled task
$taskName = 'UploadSyslog'

# Describe the scheduled task
$description = 'Task to run PowerShell script to upload syslogs at startup and every 5 minutes.'

# Set the task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -MultipleInstances Parallel -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 3 -Compatibility "Vista"

# Register the scheduled task for UploadSyslog
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger @($taskTriggerStartup, $taskTriggerRepetition) -Principal $taskUser -Description $description -Settings $settings

#

# Remove old task if needed for ReplacePrivIP
$oldtask2 = Get-ScheduledTask -TaskName "ReplacePrivIP" -ErrorAction SilentlyContinue

if ($oldtask2 -ne $null) {
    Unregister-ScheduledTask -TaskName "ReplacePrivIP" -Confirm:$false
}

# Create task action for Replace-Priv-IP
$taskAction2 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\QUT-Log-Forwarder\Set-up\Set-up Scripts\replace-priv-ip-placeholders.ps1"'

# The user to run the task
$taskUser2 = New-ScheduledTaskPrincipal -UserId 'DBS-Admin' -LogonType S4U

# The name of the scheduled task
$taskName2 = 'ReplacePrivIP'

# Describe the scheduled task
$description2 = 'Task to run PowerShell script to replace priv_ip placeholder'

# Set the task settings
$settings2 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -MultipleInstances Parallel -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 3 -Compatibility "Vista"

# Register the scheduled task for Upload-Syslog
Register-ScheduledTask -TaskName $taskName2 -Action $taskAction2 -Trigger @($taskTriggerStartup) -Principal $taskUser -Description $description2 -Settings $settings2

#

# Remove old task if needed for ReplacePubIP
$oldtask3 = Get-ScheduledTask -TaskName "ReplacePubIP" -ErrorAction SilentlyContinue

if ($oldtask3 -ne $null) {
    Unregister-ScheduledTask -TaskName "ReplacePubIP" -Confirm:$false
}

# Create task action for ReplacePubIP
$taskAction3 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\QUT-Log-Forwarder\Set-up\Set-up Scripts\replace-pub-ip-placeholders.ps1"'

# The user to run the task
$taskUser3 = New-ScheduledTaskPrincipal -UserId 'DBS-Admin' -LogonType S4U

# The name of the scheduled task
$taskName3 = 'ReplacePubIP'

# Describe the scheduled task
$description3 = 'Task to run PowerShell script to replace pub_ip placeholder'

# Set the task settings
$settings3 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -MultipleInstances Parallel -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 3 -Compatibility "Vista"

# Register the scheduled task for ReplacePubIP
Register-ScheduledTask -TaskName $taskName3 -Action $taskAction3 -Trigger @($taskTriggerStartup) -Principal $taskUser -Description $description3 -Settings $settings3

#

# Remove old task if needed for deleteIPplaceholders
$oldtask4 = Get-ScheduledTask -TaskName "DeletePlaceholderLogs" -ErrorAction SilentlyContinue

if ($oldtask4 -ne $null) {
    Unregister-ScheduledTask -TaskName "DeletePlaceholderLogs" -Confirm:$false
}

# Create task action for delete-IP-placeholders
$taskAction4 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\QUT-Log-Forwarder\Set-up\Set-up Scripts\delete-placeholder-logs.ps1"'

# The user to run the task
$taskUser4 = New-ScheduledTaskPrincipal -UserId 'DBS-Admin' -LogonType S4U

# The name of the scheduled task
$taskName4 = 'DeletePlaceholderLogs'

# Describe the scheduled task
$description4 = 'Task to run PowerShell script to delete ip placeholders'

# Set the task settings
$settings4 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -MultipleInstances Parallel -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 3 -Compatibility "Vista"

# Register the scheduled task for Replace-Pub-IP
Register-ScheduledTask -TaskName $taskName4 -Action $taskAction4 -Trigger @($taskTriggerStartup) -Principal $taskUser -Description $description4 -Settings $settings4
