[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $false)]
    [ValidateSet("PhysicalDisksInfo","VirtualDisksInfo","VolumeInfo")]
    [System.String]$Operation
)

function get-PhysicalDisksInfo()
{
<# $jsonData = @()

$disks = Get-PhysicalDisk | Select-Object -Property FriendlyName , HealthStatus

foreach ($disk in $disks) {
    $jsonData += @(@{"{#PHYSICALDISK}" = $disk.FriendlyName})
       
}
$resultData = @{"data" = $jsonData} | ConvertTo-Json
$resultData #>
$json = Get-PhysicalDisk | Select-Object -Property UniqueId, FriendlyName, HealthStatus | ConvertTo-Json -Compress
if ($json.StartsWith('{') -and $json.EndsWith('}')) {
    $json = '['+$json+']'
    return $json   
}
else {
    return $json
}
}

function Get-VolumesInfo {

$json = Get-Volume | Where-Object {$null -ne $_.DriveLetter} | Select-Object -Property DriveLetter, OperationalStatus, HealthStatus,Size,SizeRemaining | ConvertTo-Json -Compress
if ($json.StartsWith('{') -and $json.EndsWith('}')) {
    $json = '['+$json+']'
    return $json   
}
else {
    return $json
}
}

switch ($Operation) {
    "PhysicalDisksInfo" {
        get-PhysicalDisksInfo
    }
    "VirtualDisksInfo" {
        Get-JobInfo
    }
    "VolumeInfo" {
        Get-VolumesInfo
    }
    default {
        Write-Output "-- ERROR -- : Need an option  !"
        Write-Output "Valid options are: RepoInfo, JobsInfo or TotalJob"
        Write-Output "This script is not intended to be run directly but called by Zabbix."
    }
}


