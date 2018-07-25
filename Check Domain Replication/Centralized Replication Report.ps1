<#
.SYNOPSIS
    Active Directory Replication Check

.LINK
    http://github.aidan.nz

.DESCRIPTION
    Script to check replication in a multi-domain Active Directory environment

.PARAMETER Example
    Example Parameter

.INPUTS
    None

.OUTPUTS
    Log file stored in C:\Windows\Temp\<name>.log

.NOTES
    Version:            1.1
    Creation Date:      11/14/2012
    Modified Date:      06/25/2018
    Purpose/Change:
    Author:             Aidan J. McCarthy (info@aidan.nz)

	Version 1.1 - Uploaded to GitHub. Updated formatting
	Version 1.0 - Initial script

.EXAMPLE
    

#>
#-------------------------------------------------------[Initialisations]----------------------------------------------------------

$a = (Get-Host).UI.RawUI
$a.WindowTitle = "Multi-Forest Replication Report"
$a.BackgroundColor = "White"
$a.ForegroundColor = "Black"

Clear-Host

Import-Module ActiveDirectory

#$admincredential = Get-Credential

$forest = Get-Content C:\Forest_List.txt
<#
#-------------------------------------------#
#	List all domains in forest...			#
#-------------------------------------------#

$alldomains = (Get-ADForest $forest -Credential $admincredential).domains
	Write-Host " "
	Write-Host " Enumerating domains for $forest... " -BackgroundColor Red -ForegroundColor White
#>

ForEach ($line in $forest){
	Get-ADDomainController -Discover -ForceDiscover -DomainName $line -Service PrimaryDC |
	ForEach-Object {
		Write-Host " Locating PDC for" $_.Domain"... " -BackgroundColor Blue -ForegroundColor White
		Write-Host " Found PDC at" $_.IPv4Address"... " -BackgroundColor Blue -ForegroundColor White

		psexec \\$_.IPv4Address "repadmin /replsummary * /bysrc /bydest /sort:delta"

		Write-Output
		Write-Host
		Write-Host
		Write-Host
		}
	}

Write-Host " Replication check complete... Closing in 15 seconds" -BackgroundColor Green -ForegroundColor Black
Start-Sleep 15