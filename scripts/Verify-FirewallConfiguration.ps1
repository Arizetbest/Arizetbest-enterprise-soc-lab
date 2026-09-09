#Requires -RunAsAdministrator
#Requires -Version 5.1
[CmdletBinding()]
param()

Write-Host "=== Firewall profiles ===" -ForegroundColor Cyan
Get-NetFirewallProfile |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction,
        LogAllowed, LogBlocked, LogFileName, LogMaxSizeKilobytes

Write-Host "=== Active firewall rules ===" -ForegroundColor Cyan
Get-NetFirewallRule -PolicyStore ActiveStore |
    Where-Object Enabled -eq "True" |
    Select-Object DisplayName, Direction, Action, Profile |
    Sort-Object Direction, DisplayName

Write-Host "=== Firewall log files ===" -ForegroundColor Cyan
Get-NetFirewallProfile | ForEach-Object {
    $profile = $_
    $expandedPath = [Environment]::ExpandEnvironmentVariables($profile.LogFileName)
    [pscustomobject]@{
        Profile = $profile.Name
        Path    = $expandedPath
        Exists  = Test-Path -LiteralPath $expandedPath
    }
}

Write-Host "If a log does not exist, first confirm the profile is active and LogBlocked or LogAllowed is enabled, then generate matching traffic." -ForegroundColor Yellow
