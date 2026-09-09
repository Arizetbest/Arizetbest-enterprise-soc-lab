#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$DomainName = "example.local",
    [string]$DomainController = "DC-SRV01",
    [string]$ClientName = "WIN11-CLIENT"
)

$ErrorActionPreference = "Continue"

Write-Host "=== Computer and domain ===" -ForegroundColor Cyan
Get-CimInstance Win32_ComputerSystem |
    Select-Object Name, Domain, PartOfDomain

Write-Host "=== IP and DNS configuration ===" -ForegroundColor Cyan
Get-NetIPConfiguration
Resolve-DnsName -Name $DomainName
Resolve-DnsName -Name "_ldap._tcp.dc._msdcs.$DomainName" -Type SRV

Write-Host "=== Connectivity ===" -ForegroundColor Cyan
Test-NetConnection -ComputerName $DomainController -Port 53
Test-NetConnection -ComputerName $DomainController -Port 88
Test-NetConnection -ComputerName $DomainController -Port 389

if (Get-Module -ListAvailable -Name ActiveDirectory) {
    Import-Module ActiveDirectory
    Write-Host "=== Active Directory inventory ===" -ForegroundColor Cyan
    Get-ADDomain
    Get-ADForest
    Get-ADDomainController -Filter * |
        Select-Object HostName, Site, IsGlobalCatalog, OperationMasterRoles
    Get-ADUser -Filter * -Properties Enabled |
        Select-Object Name, SamAccountName, Enabled
    Get-ADGroup -Filter * |
        Select-Object Name, GroupScope, GroupCategory
    Get-ADComputer -Identity $ClientName -Properties DistinguishedName |
        Select-Object Name, Enabled, DistinguishedName
}
else {
    Write-Warning "The ActiveDirectory module is not installed on this computer."
}
