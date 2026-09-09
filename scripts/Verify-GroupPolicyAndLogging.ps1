#Requires -RunAsAdministrator
#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$ReportPath = "$env:PUBLIC\Documents\SOC-Lab-GPResult.html"
)

$ErrorActionPreference = "Stop"

Write-Host "Refreshing computer and user policy..." -ForegroundColor Cyan
gpupdate.exe /force

Write-Host "Creating Group Policy results report..." -ForegroundColor Cyan
gpresult.exe /h $ReportPath /f
Write-Host "Report: $ReportPath" -ForegroundColor Green

Write-Host "=== Applied Group Policy Objects ===" -ForegroundColor Cyan
gpresult.exe /r /scope computer

Write-Host "=== Audit policy ===" -ForegroundColor Cyan
auditpol.exe /get /category:*

Write-Host "=== PowerShell Script Block Logging ===" -ForegroundColor Cyan
$scriptBlockKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
Get-ItemProperty -Path $scriptBlockKey -ErrorAction SilentlyContinue |
    Select-Object EnableScriptBlockLogging

Write-Host "=== Recent PowerShell 4104 events ===" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-PowerShell/Operational"
    Id      = 4104
} -MaxEvents 10 -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Id, LevelDisplayName, Message

Write-Host "=== Event log size and retention ===" -ForegroundColor Cyan
foreach ($logName in "Security", "System", "Application") {
    $log = Get-WinEvent -ListLog $logName
    [pscustomobject]@{
        LogName               = $log.LogName
        MaximumSizeInBytes    = $log.MaximumSizeInBytes
        LogMode               = $log.LogMode
        IsEnabled             = $log.IsEnabled
    }
}
