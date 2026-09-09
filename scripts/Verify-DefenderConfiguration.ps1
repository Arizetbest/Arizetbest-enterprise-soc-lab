#Requires -RunAsAdministrator
#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$StartQuickScan
)

if (-not (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue)) {
    throw "Microsoft Defender Antivirus cmdlets are unavailable on this host."
}

Write-Host "=== Defender operational status ===" -ForegroundColor Cyan
Get-MpComputerStatus |
    Select-Object AntivirusEnabled, AntispywareEnabled,
        RealTimeProtectionEnabled, BehaviorMonitorEnabled,
        IoavProtectionEnabled, NISEnabled,
        AntivirusSignatureVersion, AntivirusSignatureLastUpdated,
        QuickScanAge, FullScanAge

Write-Host "=== Defender preferences ===" -ForegroundColor Cyan
Get-MpPreference |
    Select-Object DisableRealtimeMonitoring, DisableBehaviorMonitoring,
        DisableIOAVProtection, DisableScriptScanning,
        MAPSReporting, SubmitSamplesConsent, PUAProtection,
        ScanScheduleDay, ScanScheduleTime,
        SignatureUpdateInterval

if ($StartQuickScan) {
    Write-Host "Starting a Defender quick scan..." -ForegroundColor Yellow
    Start-MpScan -ScanType QuickScan
    Get-MpComputerStatus |
        Select-Object QuickScanStartTime, QuickScanEndTime, QuickScanAge
}

Write-Host "Use the harmless EICAR test only in an authorized isolated lab and record the Defender alert." -ForegroundColor Yellow
