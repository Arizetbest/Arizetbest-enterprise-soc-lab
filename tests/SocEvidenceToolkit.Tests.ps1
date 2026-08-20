BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' 'src' 'SocEvidenceToolkit' 'SocEvidenceToolkit.psd1'
    Import-Module $modulePath -Force

    function New-TestEvent {
        param(
            [int]$Id,
            [string]$UserName,
            [string]$IpAddress = '192.0.2.25'
        )

        $xml = @"
<Event>
  <EventData>
    <Data Name="TargetUserName">$UserName</Data>
    <Data Name="TargetDomainName">LAB</Data>
    <Data Name="LogonType">3</Data>
    <Data Name="IpAddress">$IpAddress</Data>
    <Data Name="WorkstationName">CLIENT01</Data>
    <Data Name="SubjectUserName">SYSTEM</Data>
  </EventData>
</Event>
"@
        $event = [pscustomobject]@{
            Id          = $Id
            TimeCreated = [datetime]'2026-08-20T10:00:00Z'
            MachineName = 'DC01.lab.local'
            RecordId    = 1001
        }
        $event | Add-Member -MemberType ScriptMethod -Name ToXml -Value { $xml }.GetNewClosure()
        $event
    }
}

Describe 'Get-SocUserLogonEvidence' {
    It 'returns only events for the requested identity' {
        $testEvents = @(
            New-TestEvent -Id 4625 -UserName 'arize' -IpAddress '192.0.2.25'
            New-TestEvent -Id 4624 -UserName 'another.user' -IpAddress '192.0.2.50'
        )

        InModuleScope SocEvidenceToolkit -Parameters @{ Events = $testEvents } {
            param($Events)
            Mock Invoke-SocGetWinEvent { $Events }

            $result = Get-SocUserLogonEvidence -Identity 'arize' -ComputerName 'DC01'

            $result | Should -HaveCount 1
            $result.EventId | Should -Be 4625
            $result.Result | Should -Be 'Failed logon'
            $result.SourceIpAddress | Should -Be '192.0.2.25'
        }
    }

    It 'rejects an invalid time range' {
        $end = Get-Date
        { Get-SocUserLogonEvidence -Identity 'arize' -StartTime $end -EndTime $end } |
            Should -Throw '*StartTime must be earlier*'
    }

    It 'returns no object when the identity does not match' {
        $testEvents = @(New-TestEvent -Id 4624 -UserName 'another.user')

        InModuleScope SocEvidenceToolkit -Parameters @{ Events = $testEvents } {
            param($Events)
            Mock Invoke-SocGetWinEvent { $Events }
            @(Get-SocUserLogonEvidence -Identity 'arize' -ComputerName 'DC01') | Should -HaveCount 0
        }
    }
}
