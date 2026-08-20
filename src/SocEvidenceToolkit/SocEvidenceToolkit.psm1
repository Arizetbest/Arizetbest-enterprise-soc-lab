Set-StrictMode -Version Latest

function Invoke-SocGetWinEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$FilterHashtable,

        [Parameter(Mandatory)]
        [string]$ComputerName,

        [Parameter(Mandatory)]
        [int]$MaxEvents
    )

    Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterHashtable -MaxEvents $MaxEvents -ErrorAction Stop
}

function ConvertFrom-SocEventRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$EventRecord
    )

    process {
        [xml]$eventXml = $EventRecord.ToXml()
        $eventData = @{}

        foreach ($dataNode in $eventXml.Event.EventData.Data) {
            if ($null -ne $dataNode.Name) {
                $eventData[[string]$dataNode.Name] = [string]$dataNode.'#text'
            }
        }

        $result = switch ([int]$EventRecord.Id) {
            4624 { 'Successful logon' }
            4625 { 'Failed logon' }
            4740 { 'Account locked out' }
            4767 { 'Account unlocked' }
            default { 'Account event' }
        }

        [pscustomobject]@{
            Timestamp       = [datetime]$EventRecord.TimeCreated
            EventId         = [int]$EventRecord.Id
            Result          = $result
            TargetUser      = $eventData['TargetUserName']
            TargetDomain    = $eventData['TargetDomainName']
            LogonType       = $eventData['LogonType']
            SourceIpAddress = $eventData['IpAddress']
            WorkstationName = if ($eventData['WorkstationName']) { $eventData['WorkstationName'] } else { $eventData['CallerComputerName'] }
            SubjectUser     = $eventData['SubjectUserName']
            Computer        = [string]$EventRecord.MachineName
            RecordId        = [long]$EventRecord.RecordId
        }
    }
}

function Get-SocUserLogonEvidence {
    <#
    .SYNOPSIS
    Collects Windows Security events relevant to a named user investigation.

    .DESCRIPTION
    Queries successful logons, failed logons, account lockouts, and account
    unlocks. Results are normalized into analyst-friendly objects without
    exporting complete event messages or unrelated user data.

    .PARAMETER Identity
    The exact sAMAccountName or user name to investigate.

    .PARAMETER ComputerName
    The Windows computer or domain controller to query. Defaults to the local
    computer. Remote collection requires suitable permissions and connectivity.

    .PARAMETER StartTime
    Earliest event timestamp. Defaults to 24 hours before execution.

    .PARAMETER EndTime
    Latest event timestamp. Defaults to the current time.

    .PARAMETER MaxEvents
    Maximum records to request before applying the user filter.

    .EXAMPLE
    Get-SocUserLogonEvidence -Identity 'soc.analyst' -ComputerName 'DC01' -StartTime (Get-Date).AddDays(-7)

    .NOTES
    Run only against systems you own or are authorized to administer.
    Security log access normally requires elevated permissions.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName = $env:COMPUTERNAME,

        [Parameter()]
        [datetime]$StartTime = (Get-Date).AddHours(-24),

        [Parameter()]
        [datetime]$EndTime = (Get-Date),

        [Parameter()]
        [ValidateRange(1, 50000)]
        [int]$MaxEvents = 5000
    )

    if ($StartTime -ge $EndTime) {
        throw 'StartTime must be earlier than EndTime.'
    }

    $filter = @{
        LogName   = 'Security'
        Id        = @(4624, 4625, 4740, 4767)
        StartTime = $StartTime
        EndTime   = $EndTime
    }

    try {
        $events = Invoke-SocGetWinEvent -ComputerName $ComputerName -FilterHashtable $filter -MaxEvents $MaxEvents
    }
    catch {
        $message = "Unable to query the Security log on '$ComputerName'. Confirm administrative permissions, connectivity, and audit policy. $($_.Exception.Message)"
        throw $message
    }

    $events |
        ConvertFrom-SocEventRecord |
        Where-Object { $_.TargetUser -ieq $Identity } |
        Sort-Object -Property Timestamp -Descending
}

Export-ModuleMember -Function Get-SocUserLogonEvidence
