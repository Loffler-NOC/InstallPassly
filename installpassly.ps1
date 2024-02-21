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

try {
    msiexec /x C:\temp\PasslyWinLogonCP.msi /qn
}
catch {
    Write-Output "Passly failed to install with error: " $_
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
    }
}
