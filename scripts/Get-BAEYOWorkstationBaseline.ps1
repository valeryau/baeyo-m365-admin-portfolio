<#
.SYNOPSIS
Collects a non-secret Windows workstation baseline for Baeyo lab documentation.

.DESCRIPTION
Writes basic device, OS, security, networking, and tool-version information.
Review the output before committing because computer/user/domain information may
still be sensitive in a public portfolio.

.NOTES
Run in PowerShell 7 as the local administrator when possible.
#>

[CmdletBinding()]
param(
    [string]$OutputDirectory = "$env:USERPROFILE\Documents\BAEYO-LAB\exports"
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outputFile = Join-Path $OutputDirectory "BAEYO-WIN-01-baseline-$timestamp.txt"

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("Baeyo Digital Workstation Baseline")
$lines.Add("Generated: $(Get-Date -Format o)")
$lines.Add("")

$lines.Add("=== SYSTEM ===")
$lines.Add("Computer name: $env:COMPUTERNAME")
$lines.Add("Current user: $env:USERNAME")
$lines.Add("PowerShell edition: $($PSVersionTable.PSEdition)")
$lines.Add("PowerShell version: $($PSVersionTable.PSVersion)")
$lines.Add("")

$os = Get-CimInstance Win32_OperatingSystem
$computer = Get-CimInstance Win32_ComputerSystem
$lines.Add("Windows caption: $($os.Caption)")
$lines.Add("Windows version: $($os.Version)")
$lines.Add("Build: $($os.BuildNumber)")
$lines.Add("Architecture: $($os.OSArchitecture)")
$lines.Add("Manufacturer: $($computer.Manufacturer)")
$lines.Add("Model: $($computer.Model)")
$lines.Add("RAM GB: $([math]::Round($computer.TotalPhysicalMemory / 1GB, 2))")
$lines.Add("")

$lines.Add("=== SECURITY ===")
try {
    $tpm = Get-Tpm
    $lines.Add("TPM present: $($tpm.TpmPresent)")
    $lines.Add("TPM ready: $($tpm.TpmReady)")
} catch {
    $lines.Add("TPM status: Unable to query")
}
try {
    $bitlocker = Get-BitLockerVolume -MountPoint "C:"
    $lines.Add("BitLocker volume status: $($bitlocker.VolumeStatus)")
    $lines.Add("BitLocker protection status: $($bitlocker.ProtectionStatus)")
} catch {
    $lines.Add("BitLocker status: Unable to query")
}
$lines.Add("")

$lines.Add("=== ENTRA / DEVICE REGISTRATION ===")
try {
    $dsreg = dsregcmd /status
    $selected = $dsreg | Select-String -Pattern "AzureAdJoined|EnterpriseJoined|DomainJoined|DeviceId|TenantName|MdmUrl"
    foreach ($line in $selected) { $lines.Add($line.Line.Trim()) }
} catch {
    $lines.Add("dsregcmd status: Unable to query")
}
$lines.Add("")

$lines.Add("=== TOOLS ===")
$commands = @("git", "code", "winget", "pwsh")
foreach ($command in $commands) {
    $found = Get-Command $command -ErrorAction SilentlyContinue
    if ($found) {
        try {
            $version = switch ($command) {
                "git" { git --version }
                "code" { (code --version | Select-Object -First 1) }
                "winget" { winget --version }
                "pwsh" { pwsh --version }
            }
            $lines.Add("$command: $version")
        } catch {
            $lines.Add("$command: installed; version query failed")
        }
    } else {
        $lines.Add("$command: not found")
    }
}

$lines | Set-Content -Path $outputFile -Encoding utf8
Write-Host "Baseline written to: $outputFile"
Write-Warning "Review and sanitize the output before committing it to any repository."
