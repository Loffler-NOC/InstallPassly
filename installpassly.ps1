#Check if Passly is already installed
$programName = "Passly Windows Logon Agent (x64)"

# Check if the program is installed
$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $programName }

if ($installed -ne $null) {
    Write-Output "$programName is already installed."
    exit 0
} else {
    # Check 32-bit registry if not found in 64-bit
    $installed = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $programName }
    if ($installed -ne $null) {
        Write-Output "$programName is already installed."
        exit 0
    } else {
        Write-Output "$programName is not installed. Continuing to installation."
    }
}

#Download the Passly installer
try {
    if (-not (Test-Path -Path "C:\Software" -PathType Container)) {
    New-Item -Path "C:\Software" -ItemType Directory
    }
    Invoke-WebRequest -Uri https://passlyprodwuappsa.blob.core.windows.net/files/PasslyWinLogonCP.msi -Outfile C:\Software\PasslyWinLogonCP.msi
}
catch {
    Write-Output "Passly was not able to be downloaded. Please check that the device is able to reach https://passlyprodwuappsa.blob.core.windows.net/files/PasslyWinLogonCP.msi . Full error message:"
    Write-Output $_
    exit 1
}

#Install Passly
try {
    msiexec /x C:\temp\PasslyWinLogonCP.msi /qn
}
catch {
    Write-Output "Passly failed to install with error: " $_
    exit 1
}

#Clean up the Passly installer
try {
    Remove-Item -Path "C:\Software\PasslyWinLogonCP.msi"
}
catch {
    Write-Output "Could not clean up installer. Please check C:\Software\PasslyWinLogonCP.msi and see if it was removed. Full error message:"
    Write-Output $_
    exit 1
}

# Check if the program is installed
$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $programName }

if ($installed -ne $null) {
    Write-Output "$programName successfully installed."
    exit 0
} else {
    # Check 32-bit registry if not found in 64-bit
    $installed = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $programName }
    if ($installed -ne $null) {
        Write-Output "$programName successfully installed."
        exit 0
    } else {
        Write-Output "$programName failed to install but did not throw an error. Please investigate."
        exit 1
    }
}
