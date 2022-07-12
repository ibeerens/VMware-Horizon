<#
.SYNOPSIS
    Poolsnapshot.ps1
.VERSION
    1.0
.DESCRIPTION
    List the Pool, Parent and snaopshot active
.NOTES
    Author(s): Ivo Beerens
    Requirements:  
        Make sure the VMware.HV.Helper module is installed, see: https://github.com/vmware/PowerCLI-Example-Scripts
        Copy the VMware.Hv.Helper to the module location.
.EXAMPLE
    PS> ./Poolsnapshot.ps1
#>

#Variables
$connectionserver = 'srv-con-01'
$domain = 'lab.local'
$date = Get-date -UFormat "%d-%m-%Y"
$output = "C:\Temp\horclients-$date.csv"

# Import module
Import-Module VMware.Hv.Helper

Write-Output "", "Connecting to the Horizon Connection Server" 
Connect-HVServer -Server $connectionserver -domain $domain

$pools = (Get-HVPool).base.name

$myCol = @() # Create empty array
ForEach ($pool in $pools) {   
        $poolname = Get-HVPool -PoolName $pool
        $row = " " | Select-Object PoolNamed, Parent, Snapshot 
        $row.PoolNamed = $poolname.Base.Name
        $row.Parent = $poolname.AutomatedDesktopData.VirtualCenterNamesData.ParentVmPath
        $row.Snapshot = $poolname.AutomatedDesktopData.VirtualCenterNamesData.SnapshotPath
        $myCol += $row
        }
Write-Output $myCol | Format-Table -AutoSize

$myCol | Out-GridView

Disconnect-HVServer * -Confirm:$false
