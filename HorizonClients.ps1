<#
.SYNOPSIS
    HorizonClient.ps1.ps1
.VERSION
    1.0
.DESCRIPTION
    List all the Connection and displays the VMware Horizon client version. 
.NOTES
    Author(s): Ivo Beerens
    Requirements:  
        Make sure the VMware.HV.Helper module is installed, see: https://github.com/vmware/PowerCLI-Example-Scripts
        Copy the VMware.Hv.Helper to the module location.
.EXAMPLE
    PS> ./HorizonClient.ps1
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

# List all Users and clients with the Horion client the are running
$localsessioninfo = (get-HVlocalsession).Namesdata | Select-Object UserName, MachineOrRDSServerName, AgentVersion, DesktopPoolCN, ClientType, ClientAddress, ClientName, ClientVersion, SecurityGatewayDNS, SecurityGatewayAddress | Sort-Object ClientVersion

# Export the output to a grid and CSV file
$localsessioninfo | Out-GridView -Title 'VMware Horizon Client versions'
$localsessioninfo | export-csv $output -Force -NoTypeInformation
