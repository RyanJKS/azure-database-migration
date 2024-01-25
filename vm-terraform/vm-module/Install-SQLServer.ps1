try {
    $sqlServerInstallerUri = "https://go.microsoft.com/fwlink/p/?linkid=2215158&clcid=0x809&culture=en-gb&country=gb"
    $ssmsInstallerUri = "https://aka.ms/ssmsfullsetup"
    $sqlServerInstaller = "C:\\SQL2022-SSEI-Dev.exe"
    $ssmsInstaller = "C:\\SSMS-Setup-ENU.exe"

    Write-Host "Downloading SQL Server installer..."
    Invoke-WebRequest -Uri $sqlServerInstallerUri -OutFile $sqlServerInstaller

    Write-Host "Installing SQL Server..."
    Start-Process -FilePath $sqlServerInstaller -ArgumentList "/Q /IACCEPTSQLSERVERLICENSETERMS" -Wait

    Write-Host "Downloading SSMS installer..."
    Invoke-WebRequest -Uri $ssmsInstallerUri -OutFile $ssmsInstaller

    Write-Host "Installing SQL Server Management Studio..."
    Start-Process -FilePath $ssmsInstaller -ArgumentList "/install /quiet /norestart" -Wait

    Write-Host "Installation completed successfully."
}
catch {
    Write-Host "An error occurred during installation: $_"
}
