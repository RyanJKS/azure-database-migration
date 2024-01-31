# Azure Database Migration

![Microsoft Azure](https://img.shields.io/badge/-Microsoft%20Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure SQL Database](https://img.shields.io/badge/-Azure%20SQL%20Database-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure Data Studio](https://img.shields.io/badge/-Azure%20Data%20Studio-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![SQL Server Management Studio (SSMS)](https://img.shields.io/badge/-SSMS-0078D4?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/-Microsoft%20Entra%20ID-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![Azure Blob Storage](https://img.shields.io/badge/-Azure%20Blob%20Storage-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Windows Virtual Machine](https://img.shields.io/badge/-Windows%20VM-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)

## Introduction
This project is a demonstration of architecting and implementing a cloud-based database system on Microsoft Azure. With a focus on cloud engineering, the project showcases the process of setting up a production environment database, migrating to Azure SQL Database, and ensuring robust data management through backup, restoration, and automated scheduling.

## Table of Contents
- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Setting Up the Production Environment](#setting-up-the-production-environment)
- [Database Migration to Azure SQL Database](#database-migration-to-azure-sql-database)
- [Securing Data and Development Environment Setup](#securing-data-and-development-environment-setup)
  - [Creating a Secure Backup of the On-Premise Database](#creating-a-secure-backup-of-the-on-premise-database)
  - [Uploading the On-Premise Backup File to Azure Blob Storage](#uploading-the-on-premise-backup-file-to-azure-blob-storage)
  - [Setting Up the Development Environment](#setting-up-the-development-environment)
  - [Automating Backups in Development Environment](#automating-backups-in-development-environment)
- [Disaster Recovery Simulation and Data Restoration](#disaster-recovery-simulation-and-data-restoration)
  - [Simulating Data Loss in Production Database](#simulating-data-loss-in-production-database)
  - [Restoring the Production Database](#restoring-the-production-database)
- [Geo-replication and Failover Configuration](#geo-replication-and-failover-configuration)
  - [Setting Up Geo-replication](#setting-up-geo-replication)
  - [Failover Simulation and Execution](#failover-simulation-and-execution)
- [Security and Access Control](#security-and-access-control)
  - [Overview of Security and Access Control](#overview-of-security-and-access-control)
  - [Microsoft Entra ID Integration for Enhanced Security](#microsoft-entra-id-integration-for-enhanced-security)
  - [Admin Setup and Role Assignment](#admin-setup-and-role-assignment)
  - [Connection Verification with Entra Credentials](#connection-verification-with-entra-credentials)
  - [Creating and Assigning Roles to New Users](#creating-and-assigning-roles-to-new-users)
  - [Testing User Permissions](#testing-user-permissions)
- [Debugging Authentication and Connectivity Issues](#debugging-authentication-and-connectivity-issues)
- [Conclusion](#conclusion)

## Project Overview
The Azure Database Migration Project is a multifaceted endeavor designed to transition an on-premise database to the Azure SQL Database. Key stages include:

1. **Setting Up the Production Environment:** Establishing a Windows Virtual Machine (VM) as the cornerstone of the production environment.

2. **Database Migration:** Migrating the database to Azure SQL Database, focusing on data backup, restoration, and automated scheduling.

3. **Disaster Recovery Simulation:** Simulating a data loss scenario to test disaster recovery processes and data restoration from backups.

4. **Geo-replication and Failover Configuration:** Enhancing data availability through geo-replication and testing failover and failback capabilities.

5. **Security Integration with Microsoft Entra ID:** Implementing Microsoft Entra ID for refined access control and enhanced security.

6. **Development Environment Setup:** Creating a separate environment for testing and experimentation, including automated backup solutions.


### Architecture Overview
The architecture diagram provides a visual representation of the setup, migration, disaster recovery, geo-replication, failover, and security configurations.

<div align="center">
  <img src="/images/architecture.PNG" alt="Architecture">
</div>


### Technology Used
- **Microsoft Azure**: Central platform for hosting and managing cloud-based database services.
- **Azure SQL Database**: Cloud-based relational database service for data storage and management.
- **Azure Data Studio**: A versatile tool for managing SQL Server, including Azure SQL Database and SQL Data Warehouse.
- **SQL Server Management Studio (SSMS)**: Integrated environment for SQL infrastructure management.
- **Microsoft Entra ID**: Identity and access management service for secure authentication.
- **Azure Blob Storage**:  Online storage service for data backup and recovery.
- **Windows Virtual Machine**: Used for creating production and development environments.

### Prerequisites
- Make sure you have an Azure account with a valid subscription.
> :bulb: **Quick Start with Terraform**: For rapid deployment in your Azure environment, this repository provides a Terraform script to automate the setup. Ensure you have the following information before you begin:
> - :key: **Service Principal Details**: Obtain the Client ID and Secret Key of your Azure Service Principal. These are used for authenticating with Azure and should be entered in the `variables.tf` file under `client_id` and `client_secret`.
> - :id: **Azure Subscription and Tenant IDs**: Your Azure Subscription ID and Tenant ID are crucial for Terraform to know where to create the resources. These go into `subscription_id` and `tenant_id` in the `variables.tf` file.
> - :bust_in_silhouette: **VM Credentials**: Choose an admin username and password for your VM. Remember, the password must comply with Azure's complexity requirements: at least one lowercase character, one uppercase character, one number, and one special character, with a length between 12 and 123 characters. Input these in `admin_username` and `admin_password`.
> - :globe_with_meridians: **Your Public IP Address**: This is required to set up network access rules for your VM. It should be added to `my_public_ip` in the `variables.tf` file.
>
> With these details in hand, proceed to the 'Usage Instructions' section. Here, you'll find steps to configure the `variables.tf` file with these values and then apply the Terraform script. This script will set up two Azure Virtual Machines with SQL Server and SQL Server Management Studio installed, an Azure SQL Server, a SQL Database in that Server, a Storage Account and related networking components, all aligned with the specifications you provide.



## Setting Up the Production Environment
To establish the foundation for our project infrastructure, begin by creating a resource group in Azure. This resource group will act as a central hub, housing all the essential components of our project, including virtual machines and other related resources.
<details>
  <summary>Open Logbook</summary>

<div align="center">
  <img src="/images/setup-vm/vm-config/create-resource-group.png "alt="Create Resource Group">
</div>

### Windows Virtual Machine Configuration
- **Provisioning the VM**: The foundation of the production environment is a **Windows Virtual Machine (VM)**, which serves as the primary server for the project. The VM is configured to replicate the operations of an on-premise system, thus providing a simulated environment for the company's database. Set the access credentials using a username and password for secure access to this VM. This step ensures controlled and authenticated access to our primary working environment.

<div align="center">
  <img src="/images/setup-vm/vm-config/create-vm-1.PNG "alt="Provision VM">
</div>

<div align="center">
  <img src="/images/setup-vm/vm-config/create-vm-2.PNG "alt="VM Admin Account">
</div>

- **Network and Firewall Settings**: Appropriate network settings and firewall rules are configured to allow remote connections via the RDP protocol. 
  - For Windows VMs, Remote Desktop Protocol (RDP) is used to enable remote access. The Administrator username and password you were prompted to set up will be used for RDP access to the VM. To avoid any issues connecting to the VM later, ensure that the RDP port (port 3389) is allowed in the NSG inbound rules for the VM. 
  
<div align="center">
  <img src="/images/setup-vm/vm-config/vm-networking.PNG" alt="VM Networking">
</div>

> Note: You have successfully created a `production-environment`.

### Remote Connection
- **Remote Desktop Protocol (RDP)**: After the VM is provisioned, a remote connection is established using the RDP protocol and Microsoft Remote Desktop. This secure connection allows for direct access to the VM's operating system, enabling efficient management and configuration.
  
<div align="center">
  <img src="/images/setup-vm/remote-connection/connect-rdp-p1.PNG" alt="Get RDP">
</div>
<div align="center">
  <img src="/images/setup-vm/remote-connection/connect-rdp-p2.PNG" alt="Access VM using RDP">
</div>
<div align="center">
  <img src="/images/setup-vm/remote-connection/connect-rdp-p3.PNG" alt="Enter VM">
</div>

### SQL Server Installation on Azure VM
The installation of **SQL Server** and **SQL Server Management Studio (SSMS)** on the **Azure VM** marks the first steps in setting up the production environment. **SQL Server** provides a robust platform for database management, capable of handling large volumes of data securely and efficiently. **SSMS** is invaluable for database administration, offering a user-friendly interface for a range of management tasks. Correctly connecting to SQL Server instances is key to efficient database operations and management across various environments.

- **SQL Server Download**: Obtain SQL Server from [Microsoft SQL Server Downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads). Select the **Basic** installation option.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/install-sql-server.PNG" alt="SQL Server Installation">
</div>

- **SQL Server Installation Completion**: Once SQL Server is installed, you will see a confirmation screen.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/sql-server-installation-complete.PNG" alt="SQL Server Installation Complete">
</div>

- **SSMS Installation**: Post SQL Server installation, use the Install SSMS button from the SQL Server Installation Wizard to navigate to the Microsoft website. Download and install the latest SSMS version from the Microsoft Download Center. Follow the on-screen instructions to install SSMS on your Azure VM.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/ssms-install.PNG" alt="SSMS Installation">
</div>

- **Connecting to SQL Server via SSMS**: After launching SSMS, you will be prompted to connect to a server. This would be pre-filled by the VM and you can access this server using different types of Authentication Methods.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/smss-login-p1.PNG" alt="Connect to Server Window">
</div>

- **Authentication Mode Selection**: Choose Windows Authentication for domain environments or SQL Server Authentication for remote or mixed-mode environments.

<div align="center">
  <img src="/images/setup-vm/sql-server-installation/smss-login-p2.PNG" alt="Authentication Mode Selection">
</div>

> Keep a note of whatever method used to access the SQL Server as it will later be used to create a connection to this server.

### AdventureWorks Database Restoration
To simulate a real-world production database, the **AdventureWorks** sample database is restored. This process exemplifies recovery scenarios and provides a rich dataset for testing. This database can be found [here](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms#download-backup-files).

- **Start Restoration:**: Right click on 'Database' and select 'Restore Database..' to start the process.

<div align="center">
  <img src="/images/setup-vm/restore-db/db-restore-p0.PNG" alt="Locate Backup File">
</div>

- **Database Backup Restoration**: Locate and restore the **AdventureWorks** backup which is currently located in the `database-backup` folder.

<div align="center">
  <img src="/images/setup-vm/restore-db/db-restore-p1.PNG" alt="Database Restoration Process">
</div>

- **Restoration Process**: Follow the SQL Server prompts to restore the database.

<div align="center">
  <img src="/images/setup-vm/restore-db/db-restore-p2.PNG" alt="Restoration in Progress">
</div>

- **Completion of Restoration**: Once the process is complete, you will have a fully functional copy of the **AdventureWorks** database.

<div align="center">
  <img src="/images/setup-vm/restore-db/db-restore-complete.PNG" alt="Restoration Complete">
</div>

With these steps, the production environment mirrors the on-premise server's functionality, providing a solid foundation for migrating to Azure SQL Database. 
</details>

## Database Migration to Azure SQL Database

### Overview
Migration of the database to Azure SQL Database is a key component of this project. This process includes data backup, restoration, and automated scheduling for ongoing data management.

<details>
  <summary>Open Logbook</summary>

### Creating an Azure SQL Server
#### Initial Setup
- **Action:** Create a new SQL Server in Azure, serving as the centralized management point for your databases.
- **Server Details:**
  - Choose a unique server name.
  - Select the closest region for optimal performance.
- **Authentication:** Focus on SQL Server Authentication using username and password.

![Creating Azure SQL Server](/images/migrate-to-sql-database/create-azure-sql-database/create-server.PNG)
![Azure SQL Server Details](/images/migrate-to-sql-database/create-azure-sql-database/azure-sql-server-details.PNG)
  
> Note: This server, `database-migration-server`, will house our `production database`.

### Creating SQL Database and Configuring Firewall Rules
#### Database Creation and Security

- **Creating SQL Database:**
  - **Action:** Choose the newly created Azure SQL server and proceed to set up your SQL Database.

![Creating SQL Database](/images/migrate-to-sql-database/create-azure-sql-database/create-sql-database.PNG)
  
- **Firewall Configuration:**
  - **Purpose:** Adjust the firewall settings to ensure secure access to the SQL Database. Make sure to add your current IP address to allow the VM to have access to this database.

![Configuring SQL Database Firewall](/images/migrate-to-sql-database/create-azure-sql-database/sql-database-firewall.PNG)

- **Database Overview:**
  - **Note:** After creating the database, make a note of the server name, which will be used for future connections.

![SQL Database Overview](/images/migrate-to-sql-database/create-azure-sql-database/sql-database-overview.PNG)


### Azure Data Studio Configuration
Azure Data Studio is a cutting-edge cross-platform solution developed by Microsoft to simplify database management and streamline the migration process. With its seamless integration with Azure services, it offers a unified interface to manage both local and cloud-based databases, making it the perfect companion for database migration.

#### Streamlining Database Management

- **Introduction to Azure Data Studio:** Get the installation package from the official [website](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio?tabs=win-install%2Cwin-user-install%2Credhat-install%2Cwindows-uninstall%2Credhat-uninstall) and install it on the VM.
      
![Opening Azure Data Studio](/images/migrate-to-sql-database/azure-data-studio-config/open-azure-data-studio.PNG)

- **Establishing Local SQL Server Connections:** Set up a connection to your local SQL Server ( `localhost`) in Azure Data Studio for direct database management.
      
![Creating Connection in Azure Data Studio](/images/migrate-to-sql-database/azure-data-studio-config/azure-studio-connection-create.PNG)

> NOTE: Use the same `Authentication Method` as the one you used to connect to the SQL Server from this [section](#sql-server-installation-on-azure-vm)

  - **Trust Server Certificate**: Enable this option to trust the SQL Server's certificate, ensuring encrypted and secure data transmission.
      
![Enabling Connection to Database](/images/migrate-to-sql-database/azure-data-studio-config/enable-connection-to-database.PNG)

  - **Successful Connection Verification:** Verify successful connection to your local SQL Server, confirming that the setup is correctly configured.
      
![Successful Connection to Database](/images/migrate-to-sql-database/azure-data-studio-config/azure-studio-connection-successful.PNG)

  - **Azure SQL Server Connection:** Establish a connection to Azure SQL Server for cloud-based database management. Use the credentials set during server provisioning which was from this [step](#database-migration-to-azure-sql-database).
      
![Connecting to Azure SQL Server](/images/migrate-to-sql-database/azure-data-studio-config/azure-studio-connect-sql-server.PNG)

  - **Troubleshooting Connection Issues:** Address connection failures to Azure SQL Server, ensuring seamless access for database operations.
      
![Azure SQL Server Connection Failed](/images/migrate-to-sql-database/azure-data-studio-config/azure-studio-sql-failed-connection.PNG)

  - **Adding Azure Account:** Integrate your Azure account within Azure Data Studio to manage Azure-based resources effectively. It will also add your current VM IP address to the server that we are trying to connect to.
      
![Azure Account Added in Azure Data Studio](/images/migrate-to-sql-database/azure-data-studio-config/azure-studio-added-azure-account.PNG)

  - **Configuring Network Settings:** You can also adjust the Azure SQL Server networking settings by directly implementing the VM IP address to facilitate secure and reliable database connections.
      
![Azure SQL Server Networking](/images/migrate-to-sql-database/azure-data-studio-config/azure-sql-server-networking.PNG)

  - **Confirming Multiple Server Connections:** After updating firewall rules, re-create the connection service to ensure that Azure Data Studio can successfully connect to both local and Azure SQL servers.
      
![Two Server Connections in Azure Data Studio](/images/migrate-to-sql-database/azure-data-studio-config/azure-studio-2-server-connection.PNG)


This section guides you through downloading and setting up Azure Data Studio, followed by establishing and troubleshooting connections to local and Azure SQL databases.


### Schema Migration
The schema migration is a pivotal step in moving our database to the cloud. We utilized the SQL Server Schema Compare extension in Azure Data Studio to manage this process effectively.
#### Aligning Database Structures

- **Extension Installation:** Install the SQL Server Schema Compare extension in Azure Data Studio to enable schema comparison.
  
![Installing SQL Server Schema Compare Extension](/images/migrate-to-sql-database/schema-migration/install-schema-compare.PNG)

- **Schema Comparison:** Compare and align schemas between Local SQL Server and Azure SQL Database for consistency and compatibility.
  
![Initiating Schema Compare](/images/migrate-to-sql-database/schema-migration/allow-schema-compare.PNG)

- **Setting Source and Target for Schema Migration:** Define your Local SQL Server as the source and Azure SQL Database as the target in the schema comparison process.
  
![Setting Source and Target for Schema Migration](/images/migrate-to-sql-database/schema-migration/schema-target-confirm-azure-sql.PNG)

- **Applying Schema Changes:** Choose the schema elements to migrate and apply the changes to synchronize your local database schema with the Azure SQL Database. Click on 'Compare' and then select all dataset before clicking on 'Apply'.
  
![Applying Schema Changes](/images/migrate-to-sql-database/schema-migration/compare-output-schema-compare.PNG)

- **Schema Migration Success Confirmation:** Ensure that the schema structures are now aligned between your local and Azure SQL databases.
  
![Schema Migration Success Confirmation](/images/migrate-to-sql-database/schema-migration/post-schema-compare-output.PNG)

With the schema migration complete, our database structure, including tables, views, and procedures, is replicated in Azure, ready for the data migration phase.

### Data Migration
Moving data from a Local SQL Server Database to Azure is a vital step in the migration process. In Azure Data Studio, we use the Azure SQL Migration extension to streamline this task.

#### Transferring Data to the Cloud

- **Extension for Migration:** Install the Azure SQL Migration extension in Azure Data Studio to facilitate the migration process.
  
![Installing Azure SQL Migration Extension](/images/migrate-to-sql-database/data-migration/azure-studio-sql-migration-extension.PNG)

- **Migration Process:** Initiate migration using the Azure SQL Migration extension by selecting the local SQL Server as the source for the data migration and click on `New Migration`
  
![Enter Migration Wizard](/images/migrate-to-sql-database/data-migration/enter-sql-migration-extension.PNG)


- **Initiating the Migration Wizard**: This will open the Migration Wizard. First choose the specific database that you want to migrate to Azure SQL Database.

![Choosing Database to Migrate](/images/migrate-to-sql-database/data-migration/migration-p1.PNG)

- **Migration Assessment:** Conduct an assessment to ensure that the selected database is ready for migration.

![Migration Assessment](/images/migrate-to-sql-database/data-migration/migration-p2.PNG)

- **Target Selection:** Select Azure SQL Database as the migration destination.

![Target Selection](/images/migrate-to-sql-database/data-migration/migration-p3.PNG)

- **Azure SQL Target Configuration:** Configure the target Azure SQL Database settings for the migration.

![Azure SQL Target Configuration](/images/migrate-to-sql-database/data-migration/migration-p4.PNG)

- **Creating Azure Database Migration Service:** Set up the Azure Database Migration Service, a key component for managing the migration process.

![Creating Azure Database Migration Service](/images/migrate-to-sql-database/data-migration/migration-p5.1.PNG)
![Azure Database Migration Service Creation](/images/migrate-to-sql-database/data-migration/migration-p5.2.PNG)

- **Integration Runtime Setup:** Install and configure the Integration Runtime, which is necessary for connecting to the Azure Database Migration Service. Then use the provided keys in Azure Data Studio to register. 

![Configuring Integration Runtime](/images/migrate-to-sql-database/data-migration/configure-runtime-app.PNG)
![Completing Integration Runtime Configuration](/images/migrate-to-sql-database/data-migration/complete-configure-integration-app.PNG)

- **Successful Connection to Migration Service:** Verify a successful connection with the Azure Database Migration Service.

![Successful Connection to Migration Service](/images/migrate-to-sql-database/data-migration/migration-p7.PNG)

- **Running Migration Validation:** Validate the readiness of the migration setup before starting the actual data transfer.

![Running Migration Validation](/images/migrate-to-sql-database/data-migration/migration-p8.PNG)

- **Select Migration Data:** After validation, choose the specific datasets to be included in the migration. In this case, select all the table within this database to be migrated.
![Migration Validation Datasets](/images/migrate-to-sql-database/data-migration/migration-p9.PNG)
![Select Migration Data](/images/migrate-to-sql-database/data-migration/migration-p10.PNG)

- **Starting the Data Migration:** Begin the data migration process and monitor its progress.

![Starting the Data Migration](/images/migrate-to-sql-database/data-migration/migration-p11.PNG)
![Monitoring Migration Progress](/images/migrate-to-sql-database/data-migration/migration-p12.PNG)


This process ensures that all data from the local server is accurately migrated to Azure SQL Database, maintaining data integrity and continuity in the cloud environment.

### Validation of Migration
- **Process:** After migration, validate the integrity and completeness of the data in Azure SQL Database.

![Validating Data Migration](/images/migrate-to-sql-database/data-migration/migration-complete.PNG)

With both schema and data successfully migrated to Azure SQL Database, we're now well-positioned to leverage the full capabilities of Azure for database management and operations.
</details>

## Securing Data and Development Environment Setup

### Introduction
This section outlines the process of securing your production database data and setting up a separate development environment for testing and experimentation, without impacting your live data. Companies often have two types of databases: one for storing real customer data (production database) and another for testing and experimenting (development database). By provisioning a development database, we will be able to test and experiment without worrying about affecting your main production data. This separation is crucial for making changes and improvements while maintaining the integrity of your live data. 

<details>
  <summary>Open Logbook</summary>

We will first ensure that the data stored in the production database is securely stored on Azure, before creating a development environment for the database. 

### Creating a Secure Backup of the On-Premise Database

- **Creating Database Backup**: Generate a full backup of the production database hosted on the Windows VM. This backup acts as a crucial safety net. On SQL Server Management Studio (SSMS) and right click on the SQL Server instance hosting your on-premise database.

![Backup Creation Process](/images/secure-data-and-environment/create-backup/create-backup-p1.png)

- **Backup Storage:** Store the resultant backup file in a designated location on your computer, ensuring its availability for future needs. In the Back Up Database dialog, choose a destination for the backup file (local path) and provide a meaningful name for the backup file. By default, the backup will be saved in `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\` or the equivalent folder in your local machine. Make sure to specify the backup type to be **Full**.

<div align="center">
  <img src="/images/secure-data-and-environment/create-backup/create-backup-p2.png" alt="Select location for backup">
</div>

- **Successful Backup:** After the backup is successful, navigate to the directory where it was saved and verify its existance.

![Backup Verification](/images/secure-data-and-environment/create-backup/create-backup-complete.png)

### Uploading Backup to Azure Blob Storage
#### Securing Backup in the Cloud
- **Setting Up Storage:** Create a storage account in Azure for housing the backup files.

![Create Storage Account](/images/secure-data-and-environment/upload-backup-azure/create-storage-account.PNG)

- **Creating Container:** Set up a container within the storage account to store the backup file.

![Create Container](/images/secure-data-and-environment/upload-backup-azure/create-database-container.PNG)

- **Uploading Backup File:** Upload the database backup file to the newly created Blob Storage container.

![Upload Backup File](/images/secure-data-and-environment/upload-backup-azure/upload-backup-p1.PNG)

- **Confirming Upload:** Ensure the backup file is successfully uploaded to Azure Blob Storage.

![Successful Upload](/images/secure-data-and-environment/upload-backup-azure/upload-backup-complete.PNG)

By uploading the on-premise backup file to Azure Blob Storage, we can securely store our backups in the cloud, ensuring data durability and availability. This enables us to implement an off-site backup strategy, enhancing the resilience of your data protection plan.


### Setting Up the Development Environment
The development environment, akin to a sandbox, allows for safe experimentation and testing without impacting the production data.

#### Establishing a Testing Ground
- **Provisioning Development VM:** Create and configure a new Windows VM for hosting the development database. Follow the steps from this [section](#windows-virtual-machine-configuration) on how to provision a VM and install SQL server and SSMS. 

![Creating Dev VM](/images/secure-data-and-environment/setup-development-env/create-vm-dev.PNG)

- **Downloading Backup File:** Connect to the new VM using RDP, which you can follow from this [step](#remote-connection), and retrieve the backup file stored in Azure Blob Storage.

![Download Blob Backup File](/images/secure-data-and-environment/setup-development-env/blob-download.PNG)

- **Restoring Database Backup:** Restore the production database backup onto the new development VM. Follow this [step](#adventureworks-database-restoration) to restore the database.

![Test Restored Backup in Dev Env](/images/secure-data-and-environment/setup-development-env/test-restored-backup-dev-env.PNG)

### Automating Backups in Development Environment
Automated backups are essential for safeguarding ongoing work and providing a quick recovery mechanism. We will now create an automated backup solution for the development environment. This solution safeguards ongoing work, aids developers in efficiently testing changes, and enables swift recovery from errors or data loss.

Using **SQL Server Management Studio (SSMS)** and its capabilities for managing periodic backups, we will create a maintenance plan for automated backups using SQL Server Maintenance Plans, and uploading these backups to Azure Blob Storage.

#### Ensuring Continuous Data Protection

- **Start SQL Server Agent:** SQL Server Agent is a component of Microsoft SQL Server that enables the scheduling, automation, and management of various administrative tasks, jobs, and alerts within SQL Server. If the Agent was started successfully you should now be able to expand the SQL Server Agent node and see the following subsections:

![Start SQL Server Agent](/images/secure-data-and-environment/periodic-backups/start-agent.png)


- **Creating SQL Server Credential:** A SQL Server Credential is a security object that allows SQL Server to access external resources securely. It is particularly useful when you need to interact with external systems, such as Azure Blob Storage, to store or retrieve data. In order to create this credential, we require an access key to the storage account that will store our backup file from the periodidc backup cycle. Navigate to the database storage on Azure portal and go to secrets to get the secret key 

![SQL Server Credential Creation](/images/secure-data-and-environment/periodic-backups/database-sotrage-access-keys.PNG)

- **Implement Credential on SMSS**: Open SSMS and connect to your SQL Server instance. Right-click on the server name and select New Query to open a new query window. Then execute the following command to create the credentials:

  ```sql
  CREATE CREDENTIAL [YourCredentialName]
  WITH IDENTITY = '[Your Azure Storage Account Name]',
  SECRET = 'Access Key';
  ```

  > Replace `[YourCredentialName]` with a name for the credential, replace and `[Your Azure Storage Account Name]` with the name of your Azure Storage account and finally replace `Access Key` with the primary access keys associated with your storage account. 

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/credentials-p1.png" alt="Start Agent">
</div>


- **Initiating Maintenance Plan:** Start configuring a maintenance plan for regular database backups.

![Maintenance Plan Setup](/images/secure-data-and-environment/periodic-backups/start-plan.png)

- **Name the Plan:** Give a descriptive name for the plan.
<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/maintenance-planp-1.PNG" alt="Plan name">
</div>

- **Maintenance Tasks for Plan:** Select the type of task to be done on this plan which in our case is the **Back Up Database (Full)**.

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/maintenance-planp-2.PNG" alt="Task for Plan">
</div>

- **Task Destination:** Select the database to back up and choose URL as the backup destination.

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/maintenance-planp-3.PNG" alt="Destination to store backup">
</div>

- **Configure Destination:** Make sure to select the SQL Credential that we previously created to ensure a secure connection to Azure, the database container which will store the backup file and in the URL make sure to change the `<storageaccount>` into the name of our storage account.

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/maintenance-planp-5.PNG" alt="Configure Destination">
</div>

- **Complete the Plan:** Click on Finish to create the Plan with all the previous settings applied within its configuration.

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/maintenance-planp-7.PNG" alt="Start Agent">
</div>

- **Executing Maintenance Plan:** Run the maintenance plan to automate the backup process.

![Execute Maintenance Plan](/images/secure-data-and-environment/periodic-backups/execute-plan.png)

- **Verifying Backup Execution:** Confirm that the plan has been executed successfully but checking the back up file in the storage container on Azure.

![Verify Backup Success](/images/secure-data-and-environment/periodic-backups/periodic-backup-success.PNG)

- **Weekly Backup Schedule**: Establish a weekly backup schedule to ensure consistent and regular protection of your evolving work in the development environment. Modify the current plan to have the flexibility on determining when the back up should take place.

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/modify-plan-p1.png" alt="Start Agent">
</div>

<div align="center">
    <img src="/images/secure-data-and-environment/periodic-backups/modify-plan-p2.png" alt="Start Agent">
</div>

By completing these steps, the production data is securely backed up and stored both locally and on Azure Blob Storage. Moreover, the establishment of a robust development environment with automated backups ensures that experimentation and testing can proceed without risk to the database.

</details>

## Disaster Recovery Simulation and Data Restoration
Disaster recovery is a critical aspect of any organization's data strategy. It refers to the set of processes and tools implemented to safeguard data, applications, and systems, enabling rapid recovery and continuity of operations in the face of disruptive events. By having a robust disaster recovery plan, businesses can minimize downtime, ensure data integrity, and maintain their ability to serve customers without significant interruptions.

<details>
  <summary>Open Logbook</summary>


### Preparing for the Unexpected
- **Importance:** Testing and ensuring the robustness of your disaster recovery strategy is crucial in handling real-world incidents.

### Simulating Data Loss in Production Database
- **Objective:** Prepare for potential data loss scenarios by simulating data removal.
  - Remove specific data from the production database and confirm the data loss.
  - Use the following SQL query to delete some data:
    ```sql
    DELETE TOP (100)
    FROM Person.[Password];
    ```
![Confirming Data Loss](/images/disaster-recovery/simulate-data-loss/data-loss-p2.PNG)

### Restoring the Production Database
- **Goal:** Restore the production database to a state before the simulated data loss. Use Azure SQL Database's backup capabilities for restoration.

![Database Restoration](/images/disaster-recovery/recover-data/data-restore-p1.PNG)

- **Restoration Point:** Pick a point in time where the data was not loss and a new descriptive name for the restored database.
  > Note: The longer the restoration time differs from the current time, the more data is loss if it is a production database as the restoration will not implement the latest data past the specified point.

![Restoration Timestamp](/images/disaster-recovery/recover-data/data-restore-p2.PNG)

- **Validate Creation of Restored Database:** Once the new restored database has been deployment, it should be visible under the resource list in Azure SQL Database page.

<div align="center">
    <img src="/images/disaster-recovery/recover-data/start-restore-p2.PNG" alt="Check restored database">
</div>


- **Validation of Restoration**: Validate the success of the restoration by examining the restored database through Azure Data Studio. First establish a connection to this new database, which resides on the same production server that we created initially using SQL authentication. Then query the database on Azure Data Studio.

<div align="center">
    <img src="/images/disaster-recovery/recover-data/start-restore-p3.PNG" alt="New connection to restored database">
</div>

<div align="center">
    <img src="/images/disaster-recovery/recover-data/start-restore-p4.PNG" alt="Check content of restored database">
</div>

- **Finalizing the Production Database**: Once the database is successfully restored and validated, it becomes the new production database. Proceed to delete the compromised database version from the Azure portal to avoid confusion.

By completing these steps, we have effectively simulated a data loss scenario and successfully restore the production database.

</details>

## Geo-replication and Failover Configuration
To maintain data availability even in adverse conditions, geo-replication and failover systems are configured. This ensures that the database remains accessible and operational across different geographical locations.

Geo-Replication is a disaster recovery feature in Azure SQL Database that provides data redundancy and high availability by asynchronously replicating your primary database to a secondary region. This secondary region is often in a different geographic location, ensuring data durability in case of a regional outage or disaster.

<details>
  <summary>Open Logbook</summary>

### Setting Up Geo-replication

- **Geographical Separation**: Start by creating a secondary server is in a different geographical region to increase redundancy and minimize shared risks.

![Geo-replica Server Setup](/images/disaster-recovery/geo-replication/geo-replica-p2.PNG)

- **Creating Replica**: Set up geo-replication by creating a replica of your production Azure SQL Database on the separate SQL server, located in a different region.

![Creating Geo-replica](/images/disaster-recovery/geo-replication/geo-replica-p1.PNG)

- **Initiate the replication process**

![Initiate Replication Process](/images/disaster-recovery/geo-replication/geo-replica-p3.PNG)

- **Finalize the geo-replication setup**: Click Review + create to initiate the replication process. Azure will start the initial data synchronization between the primary and secondary databases. In the new server, made for replication, navigate to the database which indicates that this database is a replica (as we can see under the Replica type field). 

![Finalizing Geo-replica Creation](/images/disaster-recovery/geo-replication/geo-replica-p5.PNG)

### Failover Simulation and Execution
Failover is the process of switching the workload from the primary region to the secondary region in a georeplicated environment

It is typically performed during planned maintenance or in response to a disaster in the primary region. Failover ensures high availability and business continuity by allowing applications to continue running from the secondary region.

We will orchestrate a planned failover in order to test the resilience of the system under real-world challenges.

> Note: Failback is the process of reverting the workload back to the primary region after a successful failover.

#### Orchestrating Planned Failover
- **Objective:** Conduct a planned failover to the secondary region.
  
- **Create a failover group**: Navigate to the primary server that stores the production database and create a failover group.

![Failover Process](/images/disaster-recovery/geo-replication/failover-p3.PNG)

- **Failover Group Configuration:** Use a descriptive group name and select the replication server.

![Failover Group Creation](/images/disaster-recovery/geo-replication/failover-p4.PNG)

- **Verify Failover Group:** Navigate to the replication server to check if the failover over group has been created successfully and it is linked to the production server.

![Failover Check Link](/images/disaster-recovery/geo-replication/failover-p5.PNG)

- **Perform a planned failover**: Click on the Failover group and check the current status of the live database. Click on `Failover` to test the secondary database functionality and click `Yes` to confirm.

![Failover Check Link](/images/disaster-recovery/geo-replication/failover-p7.PNG)

- **Validate Failover Region Swap:** After the failover, evaluate the availability and data consistency of the database in the secondary region.The database in the replication server is now acting as the primary database.

![Failover Validation](/images/disaster-recovery/geo-replication/failover-p8.PNG)

- **Executing Failback**: Perform a failback to the primary region, bringing operations back to the original server. Essentially re-do a failover which will swap the region of database operation back to its original state.

By following these steps, you ensure the high availability and resilience of your Azure SQL Database across different geographical conditions and operational scenarios.

</details>

## Security and Access Control
Security is a paramount concern in cloud-based systems. **Microsoft Entra ID** integration is utilized to manage access roles and provide an additional layer of security, control, and protection over the database system.

This section details the integration of **Microsoft Entra ID** authentication to strengthen database security. By enabling Microsoft Entra ID as a trusted identity provider for the SQL Server hosting the Azure SQL production database, we can manage access roles, providing an added security layer over the Azure SQL Database system.

<details>
  <summary>Open Logbook</summary>

### Admin Setup and Role Assignment
- **Admin Assignment Process:** Establishing effective user management and access control by assigning a Microsoft Entra admin. Navigate to the Azure portal and access the SQL Server used to store the production database. 

![Enter Server](/images/entra-id/assign-admin/create-admin-p1.PNG)

- **Enable Microsoft Entra ID Admin:**: In the Security section, select Microsoft Entra to manage admin roles.

![Set Admin Process](/images/entra-id/assign-admin/create-admin-p2.PNG)

- **Assigning Admin:** Set a user to become the administrator to this server which has the highest level of authority wihthin this server.

![Assigning Admin](/images/entra-id/assign-admin/create-admin-p3.PNG)

- **Finalizing Admin Assignment:** Confirm the admin registration by clicking on 'Save' and validate the user selected is now an admin.

![Finalizing Admin Assignment](/images/entra-id/assign-admin/create-admin-p4.PNG)

### Connection Verification with Entra Credentials
- **Establishing and Testing Connection:** Verifying database connection using Microsoft Entra admin credentials. Using Azure Data Studio to disconnect and re-connect to the primary database (`target-migrating-database`) in the production server (`database-migration-server`). This time, the authentication method should be **Microsoft Entra ID** when creating the connection.

![Disconnect Existing Connection](/images/entra-id/assign-admin/create-admin-p5.PNG)
![Connect with New Credentials](/images/entra-id/assign-admin/create-admin-p6.PNG)

- **Admin Data Read Confirmation:** Query the database to check if the admin has the necessary permissions within the database.

![Admin Data Read Confirmation](/images/entra-id/assign-admin/admin-read-data.PNG)

### Creating and Assigning Roles to New Users
- **Creating a DB Reader User in Microsoft Entra ID:** Generate a new user account designated as the DB Reader user. Choose a name and make a note of the complete `User principal name` as well as the domain attached to it since this will be used to access the server. Leave the `password`set as auto-generated and make a note of that as well since you will be asked to change the password on first login.

![Create User Step 1](/images/entra-id/assign-reader/create-user-p1.PNG)

![Create User Step 2](/images/entra-id/assign-reader/create-user-p2.PNG)

- **Assigning db_datareader Role:** Granting read-only privileges (`db_datareader`) to the `ryan_db_reader` user using Microsoft Entra admin credentials. Use the following command whilst being logged in as the Admin in a query:
  ```sql
  CREATE USER [DB_Reader@yourdomain.com] FROM EXTERNAL PROVIDER;
  ALTER ROLE db_datareader ADD MEMBER [DB_Reader@yourdomain.com];
  ```
> Note: `[DB_Reader]` represents the name of the Microsoft Entra user you just created. You can find the name of your domain from the Microsoft Entra Directory user page, under User principal name. The domain it's what comes after @.

![Assign Role](/images/entra-id/assign-reader/assign-user-reader.PNG)

### Testing User Permissions
- **Testing DB Reader User Access:** Confirm the read-only role assignment for the new `ryan_db_reader` user. Reconnect to the server using the new user credentials and attempt read-only and write operations to validate permissions. 

![Connection Settings](/images/entra-id/assign-reader/edit-connection-p2.PNG)

- **Read-Only Query**: Perform a simple read query where you select all data in a table.

![Query Output](/images/entra-id/assign-reader/new-user-query.PNG)

- **Delete Data Query:** Perform a deletion query to check if user has access to do that.
  
![Error on Write Attempt](/images/entra-id/assign-reader/new-user-query-failed.PNG)

An error is shown which indicates that the user doesn't have access to modify the data, but read-only access as expected.

</details>

## Debugging Authentication and Connectivity Issues

When implementing Microsoft Entra ID authentication with Azure SQL Database, various issues related to authentication and connectivity may arise. This section provides guidance on how to troubleshoot and resolve common problems effectively.

<details>
  <summary>Open Logbook</summary>

### Debugging Common Authentication Issues

#### 1. Invalid Credentials or Permissions
- **Issue Description:** Authentication fails due to incorrect credentials or insufficient permissions.
- **Resolution Steps:**
  - Ensure the Microsoft Entra user or application identity used in the connection string has the appropriate database permissions (e.g., `db_datareader`, `db_datawriter`).
  - Verify credentials and reattempt the connection.

#### 2. Missing Azure AD Registration
- **Issue Description:** Application fails to authenticate due to missing Azure AD registration.
- **Note:** Azure AD is the previous nomenclature for Microsoft Entra ID. Azure Data Studio might still reference Azure AD.
- **Resolution Steps:**
  - Confirm the application's registration in Microsoft Entra ID.
  - Obtain and use the correct client ID and tenant ID in the authentication process.

#### 3. Expired or Revoked Tokens
- **Issue Description:** Authentication tokens expire or are revoked, leading to failed connections.
- **Resolution Steps:**
  - Tokens in Azure Data Studio are valid for 12 hours. To refresh the token:
    - Remove and re-add your Azure account in Azure Data Studio.
    - Alternatively, remove the server connection and create a new connection.

By following these steps, you can effectively address common authentication and connectivity problems, ensuring a smooth and secure integration with Microsoft Entra ID and Azure SQL Database.

After implementing Microsoft Entra ID integration and setting up appropriate user roles, we have established a more secure and controlled environment. This structure not only enhances security but also ensures that each user has the appropriate level of access to the Azure SQL Database.

</details>

## Conclusion

The Azure Database Migration project represents a significant step forward in cloud-based database management and efficiency. Throughout this project, we have successfully transferred an on-premise database to the robust and scalable Azure SQL Database, ensuring data integrity and security every step of the way.

By using tools such as Azure Data Studio and SQL Server Management Studio (SSMS), we have streamlined the migration process and set up a resilient development environment. The implementation of Microsoft Entra ID and Azure Blob Storage has fortified our security measures and backup strategies, providing peace of mind through enhanced data protection and recovery options.

We also underwent rigorous testing through disaster recovery simulations, establishing geo-replication for data availability, and configuring a systematic failover approach to maintain business continuity under any circumstances.

This project has not only transitioned our database systems to the cloud but also laid a foundation for future innovation and scalability. We have embraced the capabilities of Microsoft Azure to its fullest, setting a new benchmark for operational excellence in cloud database management.

