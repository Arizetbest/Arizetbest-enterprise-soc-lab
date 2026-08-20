# Installation and First Use

## Requirements

- Windows PowerShell 5.1 or PowerShell 7 on Windows
- Permission to read the Windows Security event log
- Windows audit policy configured to record the required events
- Network connectivity and administrative authorization for remote queries

## Install from a repository clone

1. Download or clone this repository.
2. Copy `src/SocEvidenceToolkit` into a folder listed in `$env:PSModulePath`.
3. Import the module:

```powershell
Import-Module SocEvidenceToolkit -Force
```

4. Confirm the command is available:

```powershell
Get-Command -Module SocEvidenceToolkit
```

## Run an authorized investigation

```powershell
Get-SocUserLogonEvidence `
    -Identity 'soc.analyst' `
    -ComputerName 'DC01' `
    -StartTime (Get-Date).AddDays(-7)
```

Export only the minimum evidence required for the investigation:

```powershell
Get-SocUserLogonEvidence -Identity 'soc.analyst' -ComputerName 'DC01' |
    Export-Csv -Path '.\user-logon-evidence.csv' -NoTypeInformation
```

## Troubleshooting

- **Access denied:** run with an authorized administrative account or delegated Event Log Readers access.
- **No events returned:** verify the time range, exact user name, audit policy, and log retention.
- **Remote query failure:** verify name resolution, firewall rules, remote event log access, and administrative permissions.
- **Large environment:** reduce the time range or increase `MaxEvents` carefully.

Never publish real user names, addresses, domain names, IP addresses, event exports, or credentials from an employer or production environment.
