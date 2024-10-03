# Azure-Lab-Monitoring-Splunk

## Project Overview
This repository contains a logging and monitoring solution for Azure Labs Services, developed using Splunk for data visualization. The project aims to provide dashboards and alerts that track security, system health, and performance metrics for virtual machines in Azure Lab Services. 

## DISCLAIMER
The purpose of this repository is to document my own contributions to this project. I worked collaboratively on this project with one other developer. The files inside this repo were developed solely by myself, with the exception of the Alerts, which was a joint effort. There is no sensitive information contained in this repo in relation to the company or individuals involved.   

## Key Features
- **Data Ingestion**: Uses in-house developed Universal Forwarders to collect logs (Sysmon, CPU, Memory, Disk, Network) from Azure Labs.
- **Dashboards**: Visualize real-time metrics for login tracking, system health, and individual lab analysis.
- **Alerts**: Critical and daily digest alerts for issues like session times, resource usage, and virtual machine state changes.

## Technologies
- Azure Lab Services
- Splunk Cloud
- PowerShell
- Bash scripts

### Setup Instructions
1. **Install Splunk Universal Forwarder on Azure VMs:**
   - Run the `get-WIN-SPL-UF.ps1` script on Windows VMs.
   - For Linux VMs, use the `generate-ip-scripts.sh` and `lab-spl-config-QA.sh` scripts.
   
2. **Log Ingestion**:
   - Ensure the following logs are being ingested:
     - Sysmon logs for Windows (CPU, memory, disk, uptime, auth)
     - VAR logs for Linux (cpu_usage, network_tp, disk_usage)
   
3. **Dashboard Deployment**:
   - Import the `.xml` files for dashboards into Splunk.
   
4. **Alert Configuration**:
   - Configure the alerts based on SPL queries in the `/alerts` folder. These include:
     - Multiple login attempts.
     - Session times exceeding thresholds.
     - Resource usage alerts (memory, disk, CPU).

### Possible Future Enhancements
- Full migration to QUT Splunk Cloud.
- Additional alerts for network throughput monitoring.
  
## Team
- Alec Tonkin (Team Leader & Developer)
- Thomas Zegenhagen (Lead Developer & Jira Expert)
