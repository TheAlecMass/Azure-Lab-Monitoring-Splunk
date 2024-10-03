Azure-Lab-Monitoring-Splunk/
│
├── Scripts/
│   ├── Lab-Config-Scripts/
│   │   ├── Windows 11/      
│   │   │   ├── log-forwarder/
│   │   │   │   ├── README.md 
│   │   │   │   ├── Logs/
│   │   │   │   ├── Set-up/
│   │   │   │   │   ├── get-latest-WIN-SPL-download-URL.ps1  # PowerShell script retrieves the latest Splunk download URL for Windows
│   │   │   │   │   ├── Set-Forwarder.sh      # PowerShell script that runs all scripts inside /Set-up Scripts/
│   │   │   │   │   ├── Set-up Scripts/
│   │   │   │   │   │   ├── delete-placeholder-logs.ps1   
│   │   │   │   │   │   ├── get-azcopy.ps1            
│   │   │   │   │   │   ├── get-Forwarder-QA.ps1        
│   │   │   │   │   │   ├── get-SAS-AccessToken.ps1
│   │   │   │   │   │   ├── replace-priv-ip-placeholders.ps1
│   │   │   │   │   │   ├── replace-pub-ip-placeholders.ps1
│   │   │   │   │   │   ├── set-taskschedulerAndAccessPerms.ps1
│   │   │   │   ├── Scheduler/
│   │   │   │   │   ├── push-logs-to-SA.sh      # PowerShell script pushes logs inside Logs/ to Azure Storage Account
|   │ 
│   │   ├── Linux Unbuntu LTS/
│   │   │   ├── README
│   │   │   ├── setup_qut_log_forwarder.sh
│
├── Dashboard Source Code/
│   ├── Lab-health-and-security-monitor-v2.xml     # XML file for System Health Monitoring dashboard
│   ├── Lab-analysis-v2.xml      # XML file for individual Lab Analysis dashboard
│
├── Alerts SPL/
│   ├── Critical Alert - Exceed Disk Threshold
│   ├── Critical Alert - Exceed Memory Capacity Alert
│   ├── Critical Alert - Exceed Network Threshold Kbps
│   ├── Critical Alert - Session Time Over 4 Hours
│   ├── Critical Alert - Slow Starting or Stopping
│   ├── Daily Digest - Login Information
│   ├── Daily Digest - Quota Capacity 10-100%
│   ├── Daily Digest - Quota Capacity 80-100%
│
└── README.md                           # Main repository overview
