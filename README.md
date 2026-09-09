# Arizetbest Enterprise SOC Lab

![GitHub License](https://img.shields.io/github/license/Arizetbest/Arizetbest-enterprise-soc-lab)
![Last Commit](https://img.shields.io/github/last-commit/Arizetbest/Arizetbest-enterprise-soc-lab)
![Repo Size](https://img.shields.io/github/repo-size/Arizetbest/Arizetbest-enterprise-soc-lab)
![Status](https://img.shields.io/badge/status-foundation%20complete%20%7C%20hardening%20in%20progress-blue)
![Platform](https://img.shields.io/badge/platform-Windows%20Server%202025-0078D4)
![Focus](https://img.shields.io/badge/focus-SOC%20Lab%20%7C%20Blue%20Team-2ea44f)

Hands-on enterprise Security Operations Center (SOC) lab focused on Windows Server 2025, Active Directory, Group Policy, Windows 11 endpoint hardening, security logging, SIEM visibility, threat detection, and incident response practice.

<p align="center">
  <img src="https://cdn-images-1.medium.com/max/1024/1*MG68aMbpUyG52-TsyCQ0Qw.png" alt="Enterprise Active Directory OU design for the lab.local domain" width="850">
</p>

## Overview

This repository documents the build-out of a practical SOC lab designed to model core enterprise defensive operations. The lab shows how Windows infrastructure, centralized identity, endpoint configuration, Group Policy, security logging, and incident response workflows fit together in a monitored enterprise environment.

The project is structured as a professional portfolio and learning resource for SOC analyst, blue team, detection engineering, and Windows security administration skills.

## Lab Objectives

- Build a Windows-based enterprise lab with domain services and managed endpoints.
- Configure Active Directory users, groups, organizational units, and policy controls.
- Apply Windows 11 hardening through Group Policy and local security settings.
- Enable useful security telemetry from servers, endpoints, and authentication events.
- Prepare the environment for SIEM ingestion, alerting, investigation, and incident response.
- Document each major build phase with screenshots, validation steps, and operational context.

## Current SOC Lab Progress

| Area | Status | Evidence |
| --- | --- | --- |
| Active Directory OU design | Documented | Enterprise OU model for admins, departments, computers, groups, GPOs, and resources. |
| Security groups and users | Documented | Group and user placement included in the OU design workflow. |
| Windows 11 domain join | Documented | CLIENT01 workflow covers DNS preparation, domain membership, and restart validation. |
| Workstation baseline GPO | Documented | Baseline Group Policy Object linked to the Workstations OU. |
| Password policy | Documented | Default Domain Policy hardening includes password requirements. |
| Windows Update policy | Documented | Centralized Windows Update behavior configured through Group Policy. |
| Account lockout policy | Documented | Failed sign-in thresholds and lockout settings configured through Group Policy. |
| Advanced Audit Policy | Verified | Audit categories configured centrally through Group Policy. |
| PowerShell Script Block Logging | Verified | Operational log verification includes Event ID `4104`. |
| Event log sizing and retention | Verified | Security: 512 MB; System and Application: 128 MB; overwrite enabled. |
| Microsoft Defender Antivirus | In progress | Verification script added; controls are not marked complete until final validation. |
| Microsoft Defender Firewall | In progress | Profile and log-path verification script added; final logging validation remains open. |
| SIEM integration | Planned | Log forwarding, parsing, dashboards, and alerting documentation will be added as the lab matures. |
| Threat detection | Planned | Detection logic will be mapped to realistic behaviors and documented with test evidence. |
| Incident response | Planned | Triage workflows, investigation notes, and response playbooks will be added in later phases. |

## Visual Lab Evidence

### Active Directory Structure

The lab uses a structured OU design to keep administration clean, support targeted Group Policy linking, and scale identity management as the environment grows.

![Active Directory OU design](https://cdn-images-1.medium.com/max/1024/1*MG68aMbpUyG52-TsyCQ0Qw.png)

### Domain Join And Workstation Management

Windows 11 workstation onboarding is documented through the domain-join workflow, including DNS preparation, domain membership, and workstation placement.

![Windows 11 domain join overview](https://cdn-images-1.medium.com/max/1024/1*dTNI2xjUg0uKsGascRerag.png)

### Group Policy Baseline

The workstation baseline GPO provides a foundation for consistent endpoint configuration across domain-joined systems.

![Workstation baseline GPO](https://cdn-images-1.medium.com/max/1024/1*OEACIrkTthbMsEX5XBDP-A.png)

### Enterprise Security Policy Hardening

Security hardening is expanded through centralized password policy, Windows Update policy, and account lockout controls.

![Enterprise security policy hardening](https://cdn-images-1.medium.com/max/558/1*cxiYtYTA0cKTp-9IU5IScw.png)

## Build Documentation

Detailed implementation walkthroughs are published as Medium articles and referenced here as supporting build documentation:

| Topic | Article |
| --- | --- |
| Active Directory OU design | [How to Design Organizational Units (OUs) in Active Directory](https://medium.com/@arize.onubiyi/how-to-design-organizational-units-ous-in-active-directory-building-an-enterprise-ready-windows-1febca46384a) |
| Domain join and baseline GPO | [How to Configure Group Policy and Join Windows 11 to an Active Directory Domain](https://medium.com/@arize.onubiyi/how-to-configure-group-policy-and-join-windows-11-to-an-active-directory-domain-building-an-29e63fb406df) |
| Enterprise security policies | [How to Configure Enterprise Security Policies with Group Policy in Windows Server 2025](https://medium.com/@arize.onubiyi/how-to-configure-enterprise-security-policies-with-group-policy-in-windows-server-2025-hardening-416782a63907) |

## Planned Architecture

The lab is intended to represent a small enterprise environment with centralized identity, managed Windows endpoints, security telemetry, and monitoring workflows.

Expected components include:

- Domain controller running Windows Server 2025
- Active Directory domain, users, groups, and organizational units
- Windows 11 client endpoint joined to the domain
- Group Policy Objects for security baselines and audit configuration
- Centralized log collection and SIEM search capability
- Detection rules for authentication, endpoint, and policy-relevant activity
- Incident response notes and repeatable investigation procedures

## Detection And Monitoring Focus

The detection work will prioritize SOC-relevant Windows enterprise activity, including:

- Failed and successful authentication patterns
- Account lockouts and suspicious login behavior
- Privilege and group membership changes
- Policy changes and administrative activity
- Endpoint security events and audit signals
- Suspicious process, service, or persistence-related behavior
- High-value Windows Event IDs useful for triage and investigation

Future detections should include the data source, detection goal, query or rule logic, test procedure, expected result, and analyst response guidance.

## Repository Structure

```text
.
|-- LICENSE
|-- README.md
|-- docs/
|   |-- POWERSHELL_COMMANDS.md
|   `-- SOC_Lab_Master_Checklist.md
`-- scripts/
    |-- README.md
    |-- Verify-SOCLabFoundation.ps1
    |-- Verify-GroupPolicyAndLogging.ps1
    |-- Verify-DefenderConfiguration.ps1
    `-- Verify-FirewallConfiguration.ps1
```

## PowerShell Command Library

The [sanitized command reference](docs/POWERSHELL_COMMANDS.md) records the principal commands used to validate Active Directory, DNS, domain membership, Group Policy, Advanced Audit Policy, PowerShell logging, and Windows event-log retention.

Reusable scripts are available in [`scripts/`](scripts/). All public examples use placeholder infrastructure values and contain no credentials. Defender Antivirus and Defender Firewall scripts are validation helpers for work in progress; their inclusion does not mark those phases as complete.

## Documentation Roadmap

- Add a network and identity architecture diagram.
- Document the Active Directory domain design and administrative model.
- Record Group Policy settings used for endpoint hardening and audit policy.
- Create a logging matrix that maps event sources to SOC use cases.
- Add SIEM setup notes, dashboard screenshots, and useful search queries.
- Build a detection catalog with test evidence and response recommendations.
- Add incident response runbooks for common SOC alerts.

## Skills Demonstrated

- Windows Server administration
- Active Directory design and administration
- Group Policy security configuration
- Windows endpoint hardening
- Security logging and event analysis
- SIEM planning and alert triage
- Threat detection development
- Incident response documentation
- Technical documentation for security operations

## Ethical Use

This project is intended for defensive security education, blue team practice, and professional portfolio documentation. Any attack simulation, testing, or detection validation should be performed only in an isolated lab environment owned or explicitly authorized by the operator.

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.
