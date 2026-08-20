@{
    RootModule        = 'SocEvidenceToolkit.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '6a75d842-0ab7-4ae5-b38e-679f0f4a07c3'
    Author            = 'Arize Onubiyi'
    CompanyName       = 'Community'
    Copyright         = '(c) 2026 Arize Onubiyi. MIT License.'
    Description       = 'Defensive PowerShell utilities for collecting sanitized Windows SOC investigation evidence.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Get-SocUserLogonEvidence')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('SOC', 'BlueTeam', 'Windows', 'ActiveDirectory', 'IncidentResponse')
            LicenseUri = 'https://github.com/Arizetbest/Arizetbest-enterprise-soc-lab/blob/main/LICENSE'
            ProjectUri = 'https://github.com/Arizetbest/Arizetbest-enterprise-soc-lab'
        }
    }
}
