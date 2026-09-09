# PowerShell commands used in the SOC lab

> Public, sanitized command reference. Replace example names and addresses with values from your own isolated lab. Run administrative commands from an elevated PowerShell window.

## Active Directory and DNS

```powershell
Get-ADDomain
Get-ADForest
Get-ADDomainController -Filter *
Get-ADUser -Filter * -Properties Enabled
Get-ADGroup -Filter *
Get-ADComputer -Filter * -Properties DistinguishedName
Resolve-DnsName example.local
Resolve-DnsName _ldap._tcp.dc._msdcs.example.local -Type SRV
```

## Client networking and domain membership

```powershell
ipconfig /all
Get-DnsClientServerAddress -AddressFamily IPv4
Test-NetConnection DC-SRV01 -Port 53
Test-NetConnection DC-SRV01 -Port 88
Test-NetConnection DC-SRV01 -Port 389
Get-CimInstance Win32_ComputerSystem |
    Select-Object Name, Domain, PartOfDomain
```

## Group Policy

```powershell
gpupdate /force
gpresult /r /scope computer
gpresult /h "$env:PUBLIC\Documents\SOC-Lab-GPResult.html" /f
```

When writing an `if/else` block interactively, paste the entire block at once. In PowerShell, `else` must immediately follow the closing brace of its matching `if`.

```powershell
if ($condition) {
    Write-Host "Condition is true"
}
else {
    Write-Host "Condition is false"
}
```

## Audit policy and PowerShell logging

```powershell
auditpol /get /category:*
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-PowerShell/Operational"
    Id      = 4104
} -MaxEvents 10
```

## Windows event-log sizing and retention

```powershell
wevtutil gl Security
wevtutil gl System
wevtutil gl Application

Get-WinEvent -ListLog Security, System, Application |
    Select-Object LogName, MaximumSizeInBytes, LogMode, IsEnabled
```

Expected configured maximum sizes:

| Log | Size |
| --- | ---: |
| Security | 512 MB |
| System | 128 MB |
| Application | 128 MB |

## Microsoft Defender Antivirus verification

```powershell
Get-MpComputerStatus
Get-MpPreference
Update-MpSignature
Start-MpScan -ScanType QuickScan
Get-MpComputerStatus |
    Select-Object QuickScanStartTime, QuickScanEndTime, QuickScanAge
```

A common typo is `GetMp-MpComputerStatus`. The correct cmdlet is `Get-MpComputerStatus`.

## Microsoft Defender Firewall verification

```powershell
Get-NetFirewallProfile |
    Select-Object Name, Enabled, DefaultInboundAction,
        DefaultOutboundAction, LogAllowed, LogBlocked,
        LogFileName, LogMaxSizeKilobytes

Get-NetFirewallRule -PolicyStore ActiveStore |
    Where-Object Enabled -eq "True"

Get-NetFirewallProfile | ForEach-Object {
    $path = [Environment]::ExpandEnvironmentVariables($_.LogFileName)
    [pscustomobject]@{
        Profile = $_.Name
        Path    = $path
        Exists  = Test-Path -LiteralPath $path
    }
}
```

Do not hard-code `$env:SystemRoot\System32\LogFiles\Firewall\firewall.log` unless that exact path is configured. Query `LogFileName` from each active profile first.

## Safe operating notes

- Use these commands only on systems you own or are authorized to administer.
- Do not publish credentials, tokens, unredacted internal identifiers, or personal data.
- Review scripts before execution.
- Defender EICAR validation is harmless but should be performed only in the isolated lab.
