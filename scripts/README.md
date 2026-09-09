# PowerShell command library

These scripts collect the sanitized commands used to build and verify the completed Windows phases of the Enterprise SOC Lab.

## Scripts

| Script | Purpose | Run on |
| --- | --- | --- |
| `Verify-SOCLabFoundation.ps1` | Verify AD DS, DNS, domain membership, and connectivity | Domain controller or management host |
| `Verify-GroupPolicyAndLogging.ps1` | Refresh Group Policy, produce a results report, and verify audit/event-log settings | Domain-joined Windows host |
| `Verify-DefenderConfiguration.ps1` | Inspect Microsoft Defender Antivirus settings and optionally start a quick scan | Windows client |
| `Verify-FirewallConfiguration.ps1` | Inspect firewall profiles, rules, and log configuration | Windows client |

Run PowerShell as Administrator. Review every command before execution and replace example values with values from your own authorized lab.

The scripts intentionally do not contain passwords, public IP addresses, private hostnames, or other secrets. Defender and Firewall scripts are verification helpers for phases still being completed; their presence does not claim those phases are finished.
