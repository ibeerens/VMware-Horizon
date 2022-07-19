<#
.SYNOPSIS
    Export-pools.ps1
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
    PS> ./Export-pools.ps1
#>

#Variables
$connectionserver = 'srv-con-01'
$domain = 'lab.local'
$date = Get-date -UFormat "%d-%m-%Y"
$output = 'C:\Install\VMware Horizon\pool-exp'

# Import module
Import-Module VMware.Hv.Helper

Write-Output "", "Connecting to the Horizon Connection Server" 
Connect-HVServer -Server $connectionserver -domain $domain

# Exports the Horizon pools configuration to a separate json file
Write-Output "", "Connection Server pool export"
$pools = (Get-HVPool).base.name

Write-Host 'Exporting these pools to json',$pools -ForegroundColor Green
ForEach ($pool in $pools) {
    Write-Host ''
    Write-Host 'Export pool',$pool -ForegroundColor green
    Write-Host ''
    Get-hvpool -PoolName $pool | Get-HVPoolSpec -FilePath $output\$pool.json
}

Disconnect-HVServer * -Confirm:$false
