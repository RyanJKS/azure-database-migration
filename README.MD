# Azure Database Migration

## Introduction
This project is a demonstration of architecting and implementing a cloud-based database system on Microsoft Azure. With a focus on cloud engineering, the project showcases the process of setting up a production environment database, migrating to Azure SQL Database, and ensuring robust data management through backup, restoration, and automated scheduling.

## Table of Contents
- [Introduction](#introduction)
- [Architecture Overview](#architecture-overview)
- [Project Overview](#project-overview)
- [Setting Up the Production Environment](#setting-up-the-production-environment)
- [Database Migration to Azure SQL Database](#database-migration-to-azure-sql-database)
- [Disaster Recovery Simulation](#disaster-recovery-simulation)
- [Geo-replication and Failover Configuration](#geo-replication-and-failover-configuration)
- [Security and Access Control](#security-and-access-control)
- [Conclusion](#conclusion)

## Architecture Overview
Below is the architecture diagram for the Azure database migration project. This diagram provides a visual representation of the setup, migration, disaster recovery, geo-replication, failover, and security configurations.

<div align="center">
  <img src="/images/architecture.png" alt="Architecture">
</div>

## Project Overview
The project encompasses several key phases:
1. Setting up the production environment database.
2. Migrating the database to Azure SQL Database while emphasizing data backup, restoration, and scheduling.
3. Simulating a disaster recovery scenario to prepare for potential data loss.
4. Implementing geo-replication and configuring failover to ensure continuous data availability.
5. Integrating Microsoft Entra ID to refine access control and enhance system security.

Each phase is designed to build upon the previous steps to create a robust and secure cloud-based database system.

## Setting Up the Production Environment
The foundation of the production environment is a **Windows Virtual Machine (VM)**, which serves as the primary server for the project. The VM is configured to replicate the operations of an on-premise system, thus providing a simulated environment for the company's database.

> :bulb: **Quick Start with Terraform**: If you're looking to get up and running without manual setup, this repo offers a Terraform script that can do the heavy lifting for you. Make sure you have the following details on hand before you start:
> - :key: Service Principal Client ID
> - :closed_lock_with_key: Secret Key
> - :id: Subscription ID and Tenant ID
> - :bust_in_silhouette: Username and password for the VM
> - :globe_with_meridians: Your Public IP address
>
> With these items, you can swiftly provision your Azure resources with Terraform, streamlining your initial setup process.

### Windows Virtual Machine Configuration
- **Provisioning the VM**: A VM has been set up to emulate a Windows server within Azure. It acts as a secure and dedicated data storage solution. 
  - Start by creating a resource group
  - Create a VM within that resource group with **Windows 11 Pro** and implement a username and password to access this VM.
  
<div align="center">
  <img src="/images/setup-vm/vm-config/create-resource-group.png "alt="orders-list">
</div>

<div align="center">
  <img src="/images/setup-vm/vm-config/create-vm-1.PNG "alt="orders-list">
</div>

<div align="center">
  <img src="/images/setup-vm/vm-config/create-vm-2.PNG "alt="orders-list">
</div>

- **Network and Firewall Settings**: Appropriate network settings and firewall rules are configured to allow remote connections via the RDP protocol. 
  - For Windows VMs, Remote Desktop Protocol (RDP) is used to enable remote access. The Administrator username and password you were prompted to set up will be used for RDP access to the VM. To avoid any issues connecting to the VM later, ensure that the RDP port (port 3389) is allowed in the NSG inbound rules for the VM. 
  
<div align="center">
  <img src="/images/setup-vm/vm-config/vm-networking.PNG" alt="orders-list">
</div>

<div align="center">
  <img src="/images/setup-vm/vm-config/vm-create-complete.PNG" alt="orders-list">
</div>

### Remote Connection
- **Remote Desktop Protocol (RDP)**: After the VM is provisioned, a remote connection is established using the RDP protocol and Microsoft Remote Desktop. This secure connection allows for direct access to the VM's operating system, enabling efficient management and configuration.
  
<div align="center">
  <img src="/images/setup-vm/remote-connection/connect-rdp-p1.PNG" alt="orders-list">
</div>
<div align="center">
  <img src="/images/setup-vm/remote-connection/connect-rdp-p2.PNG" alt="orders-list">
</div>
<div align="center">
  <img src="/images/setup-vm/remote-connection/connect-rdp-p3.PNG" alt="orders-list">
</div>

### SQL Server Installation on Azure VM
The installation of SQL Server and SQL Server Management Studio (SSMS) on the Azure VM marks the first steps in setting up the production environment. SQL Server provides a robust platform for database management, capable of handling large volumes of data securely and efficiently. It supports both SQL and Transact-SQL (T-SQL), making it a staple in enterprise environments.

- **SQL Server Download**: Obtain SQL Server from [Microsoft SQL Server Downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads). Select the **Basic** installation option.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/install-sql-server.PNG" alt="SQL Server Installation">
</div>

- **SQL Server Installation Completion**: Once SQL Server is installed, you will see a confirmation screen.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/sql-server-installation-complete.PNG" alt="SQL Server Installation Complete">
</div>

- **SSMS Installation**: Post SQL Server installation, utilize the Install SSMS button from the SQL Server Installation Wizard to navigate to the Microsoft website. Download and install the latest SSMS version from the Microsoft Download Center.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/ssms-download.PNG" alt="Download SSMS">
</div>

- **SSMS Installation Process**: Follow the on-screen instructions to install SSMS on your Azure VM.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/ssms-install.PNG" alt="SSMS Installation">
</div>

- **Connecting to SQL Server via SSMS**: After launching SSMS, you will be prompted to connect to a server. Input the server name or IP address. For local instances, 'localhost' can be used.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/smss-login-p1.PNG" alt="Connect to Server Window">
</div>

- **Authentication Mode Selection**: Choose Windows Authentication for domain environments or SQL Server Authentication for remote or mixed-mode environments.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/smss-login-p2.PNG" alt="Authentication Mode Selection">
</div>

### AdventureWorks Database Restoration
To simulate a real-world production database, the AdventureWorks sample database is restored. This process exemplifies recovery scenarios and provides a rich dataset for testing.

- **Database Backup Restoration**: Locate and restore the AdventureWorks backup from the `database-backup` folder.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/db-restore-p0.PNG" alt="Locate Backup File">
</div>

- **Restoration Process**: Follow the SQL Server prompts to restore the database.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/db-restore-p1.PNG" alt="Database Restoration Process">
</div>

- **Completion of Restoration**: Once the process is complete, you will have a fully functional copy of the AdventureWorks database.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/db-restore-p2.PNG" alt="Restoration in Progress">
</div>
<div align="center">
  <img src="/images/setup-vm/sql-server-installation/db-restore-complete.PNG" alt="Restoration Complete">
</div>

With these steps, the production environment mirrors the on-premise server's functionality, providing a solid foundation for migrating to Azure SQL Database. Azure VMs offer a versatile and scalable environment for SQL Server, enhancing infrastructure management and allowing for adaptive scaling of database services. SSMS is invaluable for database administration, offering a user-friendly interface for a range of management tasks. Correctly connecting to SQL Server instances is key to efficient database operations and management across various environments.

## Database Migration to Azure SQL Database
A critical component of this project is the migration of the database to Azure SQL Database. This process includes:
- Data backup: Ensuring that data is securely backed up before migration.
- Restoration: Validating that data can be restored successfully post-migration.
- Automated scheduling: Implementing scheduled tasks for ongoing data management.

## Disaster Recovery Simulation
This phase simulates a disaster recovery situation to evaluate the system's response to data loss. It is an essential test of the database's resilience and the effectiveness of the recovery strategy.

<!-- TODO: Insert image here to demonstrate the disaster recovery process -->

## Geo-replication and Failover Configuration
To maintain data availability even in adverse conditions, geo-replication and failover systems are configured. This ensures that the database remains accessible and operational across different geographical locations.

<!-- TODO: Insert image here to illustrate geo-replication and failover setup -->

## Security and Access Control
Security is a paramount concern in cloud-based systems. Microsoft Entra ID integration is utilized to manage access roles and provide an additional layer of security, control, and protection over the database system.

<!-- TODO: Insert image here to show the security configuration -->

## Conclusion
The project illustrates a comprehensive approach to cloud-based database management on Microsoft Azure. The documentation will be updated with detailed steps, configurations, and best practices as the project progresses.

<!-- TODO: Insert any concluding images or diagrams if necessary -->
