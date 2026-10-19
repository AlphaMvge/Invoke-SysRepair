<#
.SYNOPSIS
    Invoke-SysRepair PowerShell Module
.DESCRIPTION
    Module providing zero-reboot system repair, component store triage,
    online self-healing disk maintenance, and network stack restoration.
#>

function Invoke-SysRepair {
    [CmdletBinding()]
    param(
        [ValidateSet("Interactive", "Full", "Integrity", "Disk", "Network", "Cache", "Startup", "DeepClean")]
        [string]$Mode = "Interactive",

        [switch]$NonInteractive,
        [switch]$ExportReport,
        [string]$ReportPath
    )

    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "Invoke-SysRepair.ps1"
    & $scriptPath @PSBoundParameters
}

function Test-SystemHealth {
    [CmdletBinding()]
    param()

    Write-Host "[TEST-SYSTEMHEALTH] Performing rapid zero-reboot triage..." -ForegroundColor Cyan
    $results = [ordered]@{}

    # 1. DISM Health
    $dismCheck = DISM.exe /Online /Cleanup-Image /CheckHealth 2>&1 | Out-String
    $results["ComponentStore"] = if ($dismCheck -match "No component store corruption detected") { "Healthy" } else { "NeedsRepair" }

    # 2. Disk C: Health
    try {
        $vol = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue
        $results["Disk_C_Health"] = $vol.HealthStatus
        $results["Disk_C_FreeGB"] = [math]::Round($vol.SizeRemaining / 1GB, 2)
    } catch {
        $results["Disk_C_Health"] = "Unknown"
    }

    # 3. Network Connectivity
    $gwPing = Test-Connection -TargetName "1.1.1.1" -Count 1 -Quiet -ErrorAction SilentlyContinue
    $results["InternetConnectivity"] = if ($gwPing) { "Connected" } else { "Offline" }

    # 4. DNS Resolution
    $dnsOk = $false
    try {
        if ([System.Net.Dns]::GetHostAddresses("google.com")) { $dnsOk = $true }
    } catch {}
    $results["DnsResolution"] = if ($dnsOk) { "Functional" } else { "Failing" }

    [PSCustomObject]$results
}

Export-ModuleMember -Function Invoke-SysRepair, Test-SystemHealth
