<#
.SYNOPSIS
Imports a cert from WACS renewal into the RRAS service

.DESCRIPTION
Note that this script is intended to be run via the install script plugin from win-acme via the batch script wrapper. As such, we use positional parameters to avoid issues with using a dash in the cmd line. 

Proper information should be available here

https://github.com/PKISharp/win-acme/wiki/Install-Script

or more generally, here

https://github.com/PKISharp/win-acme/wiki/Example-Scripts

.PARAMETER NewCertThumbprint
The exact thumbprint of the cert to be imported. The script will copy this cert to the Personal store if not already there. 

.EXAMPLE 

ImportRRAS.ps1 <certThumbprint>

.NOTES

#>

param(
    [Parameter(Position=0,Mandatory=$true)]
    [string]$NewCertThumbprint
)

$CertInStore = Get-ChildItem -Path Cert:\LocalMachine\My -Recurse | Where-Object { $_.thumbprint -eq $NewCertThumbprint} | Sort-Object -Descending | Select-Object -f 1
if ($CertInStore) 
{
    try 
	{
        Set-RemoteAccess -SslCertificate $CertInStore.Thumbprint -ErrorAction Stop
    } 
	catch 
	{
        "Cert thumbprint was not set successfully to RRAS"
        "Error: $($Error[0])"
		return
    }
} 
else 
{
    "Cert thumbprint not found in the My cert store... have you specified --certificatestore My?"
}
