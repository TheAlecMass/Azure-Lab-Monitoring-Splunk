# Azure-Lab-Monitoring-Splunk

## Project Overview
This repository contains a logging and monitoring solution for Azure Labs Services, developed using Splunk for data visualization. The project aims to provide dashboards and alerts that track security, system health, and performance metrics for virtual machines in Azure Lab Services. 

## DISCLAIMER
The purpose of this repository is to document my own contributions to this project. I worked collaboratively on this project with one other developer, Thomas Zegenhagen. The files inside this repo were developed solely by myself, with the exception of the Alerts, which was a joint effort. No sensitive information contained in this repo exists in relation to the company or individuals involved.   

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

# Dashboards
### Lab Analysis Dashboard
![image](https://github.com/user-attachments/assets/1a6e1484-8b90-409b-ad80-e6cff2a4bfa9)

**Overview**

The Lab Analysis Dashboard gathers logs at the virtual machine level to give valuable system data that can give insight into security, health and performance. The two key logs that the dashboard collects are VAR logs and Sys logs for Linux and Windows respectively. This dashboard builds upon the Lab Health and Security Dashboard to give deeper-level metrics for individual virtual machines.

#

### Lab Health and Security Monitoring Dashboard
<img width="1920" alt="Lab-Health-and-Security-Dashboard" src="https://github.com/user-attachments/assets/19e6b745-f53c-4181-856e-ac4399c4a23c" />

**Overview**

The Lab Health and Security Monitoring Dashboard gathers logs at the Virtual Machine level to give valuable system data that can give insight into security, health and performance. The two key logs that the dashboard collects are VAR logs and Sys logs for Linux and Windows respectively. The visualisation of this dashboard can ensure that the virtual machines are performing well enough for the classes and can give insight into the performance needed for future semesters needs.

#

### Login Tracking Dashboad
![Login Tracking Dashboad](https://github.com/user-attachments/assets/7fc5d5d8-47fd-4ae6-ab9c-b2572ff6c054)

**Overview**

The Login Tracking Dashboard includes data primarily gathered from RestAPI logs and Network Security Group flow logs to give a good overview of login information. Focused primarily on being a good overall visual of current and historical data over time.

#

### Possible Future Enhancements
- Full migration to QUT Splunk Cloud.
- Additional alerts for network throughput monitoring.

# Demo

https://github.com/user-attachments/assets/120bd1fa-8dd0-4a58-a8ec-4db13bd58242

## Team
- Alec Tonkin (Team Leader & Developer)
- Thomas Zegenhagen (Lead Developer & Jira Expert)
