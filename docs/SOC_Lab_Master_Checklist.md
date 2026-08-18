# Enterprise SOC Lab — Public Completion Checklist

> Sanitized portfolio version. Internal infrastructure identifiers have been replaced with examples.

**Owner:** Lab Owner  
**Environment:** VMware Workstation on a Windows host; VM storage on a 2 TB external SSD  
**Active Directory domain:** `example.local`  
**Domain controller:** `DC-SRV01` — Windows Server 2025 — `192.168.x.x`  
**Domain workstation:** `WIN11-CLIENT` — Windows 11  
**Portfolio repository:** `Arizetbest-enterprise-soc-lab`

This is the authoritative progress tracker for the complete enterprise SOC home lab. Update each checkbox only after configuration and verification are complete.

## Phase 1 — VMware and Core Infrastructure

- [x] Install and configure VMware Workstation
- [x] Store lab virtual machines on the external SSD
- [x] Install Windows Server 2025
- [x] Rename the server to `DC-SRV01`
- [x] Configure static IPv4 address `192.168.x.x`
- [x] Configure the VMware lab network
- [ ] Record the final subnet, gateway, DHCP range, and reserved addresses
- [ ] Create a clean VMware snapshot of every completed core VM

## Phase 2 — Active Directory and DNS

- [x] Install Active Directory Domain Services
- [x] Install DNS Server
- [x] Create the `example.local` forest and domain
- [x] Promote `DC-SRV01` to a domain controller
- [x] Verify the Global Catalog and FSMO roles
- [x] Verify DNS and LDAP SRV records
- [x] Create the organizational unit structure
- [x] Create domain users
- [x] Create security groups
- [x] Create `GG_SOC_Analysts`
- [ ] Review OU and group naming for duplicates or incorrectly created objects
- [ ] Export the final AD inventory for documentation

## Phase 3 — Windows 11 SOC Workstation

- [x] Install Windows 11
- [x] Rename the computer to `WIN11-CLIENT`
- [x] Create the local `LabAdmin` account
- [x] Configure DNS to use `192.168.x.x`
- [x] Verify connectivity to `DC-SRV01` and `example.local`
- [x] Join `WIN11-CLIENT` to `example.local`
- [x] Move `WIN11-CLIENT` into the Workstations OU
- [x] Verify domain sign-in and computer membership

## Phase 4 — Group Policy Foundation

- [x] Create and link the initial workstation GPOs
- [x] Apply and test password policy
- [x] Apply and test account lockout policy
- [x] Configure Windows Update policy
- [x] Configure Windows Update restart notifications
- [x] Configure Advanced Audit Policy
- [x] Enable PowerShell Script Block Logging
- [x] Verify PowerShell Event ID `4104`
- [ ] Export a Group Policy Results report for `WIN11-CLIENT`
- [ ] Back up the completed GPOs

## Phase 5 — Windows Event Log Sizing and Retention

- [x] Create `SOC – Windows Event Log Policy`
- [x] Configure Security log maximum size: `524288 KB` (512 MB)
- [x] Configure System log maximum size: `131072 KB` (128 MB)
- [x] Configure Application log maximum size: `131072 KB` (128 MB)
- [x] Configure logs to overwrite older events when full
- [x] Disable automatic backup when full for Security, System, and Application logs
- [x] Link the policy to the Workstations OU
- [x] Link the policy to the Domain Controllers OU
- [x] Run `gpupdate /force` on `DC-SRV01` and `WIN11-CLIENT`
- [x] Verify sizes using `wevtutil gl Security`, `System`, and `Application`
- [ ] Verify GPO application using `gpresult /r /scope computer`

## Phase 6 — Microsoft Defender Antivirus

- [ ] Create and link the Defender Antivirus GPO
- [ ] Enable real-time protection
- [ ] Enable behavior monitoring
- [ ] Enable downloaded-file and attachment scanning
- [ ] Enable script scanning
- [ ] Enable cloud-delivered protection
- [ ] Configure automatic sample submission appropriately
- [ ] Configure daily quick scans
- [ ] Configure weekly full scans
- [ ] Configure security intelligence updates
- [ ] Enable potentially unwanted application protection
- [ ] Verify Defender status with PowerShell
- [ ] Generate and record a safe EICAR detection test

## Phase 7 — Microsoft Defender Firewall

- [ ] Create and link the Defender Firewall GPO
- [ ] Enable Domain, Private, and Public profiles
- [ ] Block unsolicited inbound connections by default
- [ ] Permit required domain-management traffic
- [ ] Enable dropped-packet logging
- [ ] Enable successful-connection logging where appropriate
- [ ] Increase firewall log size
- [ ] Verify applied firewall profiles and rules
- [ ] Test an allowed connection and a blocked connection

## Phase 8 — Endpoint Hardening

- [ ] Configure Microsoft Defender Attack Surface Reduction rules in audit mode
- [ ] Review ASR events before changing selected rules to block mode
- [ ] Configure Exploit Protection
- [ ] Restrict removable storage/USB devices
- [ ] Harden Remote Desktop access
- [ ] Require Network Level Authentication for RDP
- [ ] Disable SMBv1
- [ ] Configure SMB signing
- [ ] Disable unnecessary local administrator access
- [ ] Configure screen-lock and inactivity timeout
- [ ] Configure Windows LAPS for local administrator password management
- [ ] Evaluate BitLocker for workstation disks
- [ ] Verify all baseline workstation settings

## Phase 9 — Ubuntu SOC Server and Wazuh

- [ ] Create the Ubuntu Server VM
- [ ] Assign a static IP address and hostname
- [ ] Apply Ubuntu updates and basic SSH hardening
- [ ] Install Docker only if required by the chosen deployment method
- [ ] Install the Wazuh indexer
- [ ] Install the Wazuh manager
- [ ] Install the Wazuh dashboard
- [ ] Verify Wazuh service health and dashboard access
- [ ] Install a Wazuh agent on `DC-SRV01`
- [ ] Install a Wazuh agent on `WIN11-CLIENT`
- [ ] Confirm both agents are active
- [ ] Ingest Security, System, Application, Defender, Firewall, and PowerShell logs
- [ ] Configure Windows event-channel collection
- [ ] Configure file-integrity monitoring
- [ ] Configure vulnerability detection
- [ ] Configure useful alerts and email/notification options
- [ ] Create a Wazuh snapshot and document recovery steps

## Phase 10 — Additional Lab Machines

### Windows 10 User Workstation

- [ ] Create an isolated Windows 10 VM for legacy-user testing
- [ ] Patch it to the latest version available for the selected edition
- [ ] Rename and join it to `example.local`
- [ ] Place it in the appropriate workstation OU
- [ ] Install the Wazuh agent
- [ ] Verify GPO application and event ingestion

### Kali Linux Attacker

- [ ] Install Kali Linux
- [ ] Update packages and VMware tools
- [ ] Assign the documented attacker IP address
- [ ] Take a clean snapshot
- [ ] Restrict Kali to the isolated lab network during exercises
- [ ] Verify connectivity only to authorized lab targets

### Ubuntu Web Server

- [ ] Create a separate Ubuntu Server VM
- [ ] Configure static networking and hostname
- [ ] Install and secure Apache or Nginx
- [ ] Deploy a harmless practice web application
- [ ] Install the Wazuh agent
- [ ] Send web access and error logs to Wazuh
- [ ] Validate web-attack alerts

### Metasploitable 2

- [ ] Import Metasploitable 2
- [ ] Place it on the isolated lab network only
- [ ] Confirm it has no bridged exposure to the home or public network
- [ ] Take a clean snapshot
- [ ] Record its IP address and available training services

## Phase 11 — Security Onion Network Monitoring

- [ ] Confirm the host has sufficient CPU, RAM, and SSD capacity
- [ ] Create Security Onion management and monitoring interfaces
- [ ] Configure VMware port mirroring or an equivalent traffic-monitoring design
- [ ] Install Security Onion
- [ ] Complete initial administrator and sensor configuration
- [ ] Verify Zeek metadata ingestion
- [ ] Verify Suricata alert ingestion
- [ ] Verify packet capture visibility
- [ ] Test detection with approved lab traffic
- [ ] Document Security Onion dashboards and investigation workflow

## Phase 12 — Microsoft Sentinel Integration

- [ ] Create or select an Azure subscription/resource group
- [ ] Create a Log Analytics workspace
- [ ] Enable Microsoft Sentinel
- [ ] Configure approved data connectors
- [ ] Forward selected Windows/Linux security data
- [ ] Create KQL hunting queries
- [ ] Create analytics rules
- [ ] Create workbooks and dashboards
- [ ] Configure incidents and automation rules
- [ ] Map detections to MITRE ATT&CK
- [ ] Test ingestion, alerting, and incident creation
- [ ] Monitor Azure usage and cost controls

## Phase 13 — Detection and Incident-Response Exercises

- [ ] Establish written rules of engagement and authorized targets
- [ ] Test repeated failed sign-ins and account lockout detection
- [ ] Test PowerShell logging and suspicious command detection
- [ ] Test Defender malware prevention with EICAR
- [ ] Test firewall deny-event monitoring
- [ ] Test web reconnaissance and authentication alerts
- [ ] Test approved vulnerability scanning against Metasploitable 2
- [ ] Investigate events in Wazuh, Security Onion, and Sentinel
- [ ] Build timelines for each exercise
- [ ] Map each exercise to MITRE ATT&CK
- [ ] Create incident tickets and analyst notes
- [ ] Write containment, eradication, and recovery actions
- [ ] Complete lessons-learned reports

## Phase 14 — Documentation and Portfolio

- [ ] Maintain the GitHub repository `Arizetbest-enterprise-soc-lab`
- [ ] Complete the professional `README.md`
- [ ] Add Shields.io project badges
- [ ] Add a sanitized architecture diagram
- [ ] Add the implementation checklist and progress table
- [ ] Add PowerShell, Linux, and verification scripts
- [ ] Add sanitized GPO reports and configuration evidence
- [ ] Add Wazuh, Security Onion, and Sentinel screenshots
- [ ] Remove passwords, tokens, public IP addresses, personal data, and sensitive IDs
- [ ] Publish Medium articles for major phases
- [ ] Publish LinkedIn progress posts
- [ ] Record short demonstration videos
- [ ] Add troubleshooting notes and lessons learned
- [ ] Add incident reports and MITRE mappings
- [ ] Perform a final repository security review

## Final Acceptance Tests

- [ ] Every required VM starts successfully from the external SSD
- [ ] `DC-SRV01` provides working AD DS and DNS services
- [ ] Domain clients authenticate and receive the correct GPOs
- [ ] Endpoint security controls are enabled and verified
- [ ] Wazuh receives logs from all intended endpoints
- [ ] Security Onion observes authorized lab-network traffic
- [ ] Sentinel receives the selected cloud-forwarded telemetry
- [ ] Approved attack simulations create visible and explainable alerts
- [ ] Incident-response procedures are tested end to end
- [ ] VMware snapshots and configuration backups are current
- [ ] The public portfolio contains no secrets or sensitive identifiers
- [ ] The GitHub repository clearly demonstrates enterprise SOC skills

## Current Resume Point

**Next task:** Phase 6 — Microsoft Defender Antivirus.  
**Continue with:** Create and link a dedicated Microsoft Defender Antivirus GPO, enable the core protection settings, then verify them on `WIN11-CLIENT`.

## Progress Log

| Date | Phase | Work completed | Verification/evidence | Next action |
|---|---|---|---|---|
| 2026-08-17 | Saved checkpoint | Completed through PowerShell Script Block Logging | Event ID `4104` confirmed | Configure Windows Event Log sizing and retention |
| 2026-08-17 | Phase 5 | Created the Windows Event Log GPO and configured the Security log | Security log policy entered | Begin Step 3: configure the System log |
| 2026-08-18 | Phase 5 | Linked `SOC – Windows Event Log Policy` to the Workstations OU | Screenshot confirms the link is enabled | Link the policy to the Domain Controllers OU |
| 2026-08-18 | Phase 5 | Verified Security at 512 MB and System/Application at 128 MB | `wevtutil` output confirms all three maximum sizes | Disable Security automatic backup and confirm the Domain Controllers OU link |
| 2026-08-18 | Phase 5 completed | Verified overwrite behavior and disabled automatic backup for all three logs | Security shows `retention: false`, `autoBackup: false`, and `maxSize: 536870912` | Begin Microsoft Defender Antivirus GPO |
