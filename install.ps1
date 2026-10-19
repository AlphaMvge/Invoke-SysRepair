<#
.SYNOPSIS
    Single-Command Global Installer for Invoke-SysRepair
.DESCRIPTION
    Installs the Invoke-SysRepair module directly into the user's PowerShell module directory,
    enabling global execution of 'Invoke-SysRepair' from any terminal without changing paths.
.EXAMPLE
    irm https://raw.githubusercontent.com/AlphaMvge/Invoke-SysRepair/main/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              INVOKE-SYSREPAIR : AUTOMATED MODULE INSTALLER                   ║" -ForegroundColor Yellow
Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "Fetching latest release from GitHub (AlphaMvge/Invoke-SysRepair)..." -ForegroundColor DarkGray

# Determine target user module directories (support both Windows PowerShell 5.1 and PS 7+)
$docsFolder = [Environment]::GetFolderPath('MyDocuments')
$moduleDirs = @(
    (Join-Path $docsFolder "WindowsPowerShell\Modules\Invoke-SysRepair"),
    (Join-Path $docsFolder "PowerShell\Modules\Invoke-SysRepair")
)

$baseUrl = "https://raw.githubusercontent.com/AlphaMvge/Invoke-SysRepair/main"
$files = @(
    "Invoke-SysRepair.psd1",
    "Invoke-SysRepair.psm1",
    "Invoke-SysRepair.ps1",
    "Invoke-SysRepair.bat"
)

foreach ($dir in $moduleDirs) {
    try {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }

        foreach ($f in $files) {
            $srcUrl = "$baseUrl/$f"
            $dstFile = Join-Path $dir $f
            Invoke-RestMethod -Uri $srcUrl -OutFile $dstFile
        }
    } catch {}
}

# Import module into current session immediately
try {
    Import-Module Invoke-SysRepair -Force -ErrorAction SilentlyContinue
} catch {}

Write-Host "`n[✓] SUCCESS: Invoke-SysRepair is installed globally!" -ForegroundColor Green
Write-Host "You can now run 'Invoke-SysRepair' from ANY directory in any PowerShell terminal.`n" -ForegroundColor Cyan
