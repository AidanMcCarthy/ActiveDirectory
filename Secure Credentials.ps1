<#
.SYNOPSIS
    Secure Credentials

.LINK
    http://github.aidan.nz

.DESCRIPTION
    Script to create encrypted file containing secure credentials

.PARAMETER Example
    Example Parameter

.INPUTS
    None

.OUTPUTS
    Log file stored in C:\Windows\Temp\<name>.log

.NOTES
    Version:            1.1
    Creation Date:      11/14/2012
    Modified Date:      06/29/2018
    Purpose/Change:
    Author:             Aidan J. McCarthy (info@aidan.nz)

	Version 1.1 - Uploaded to GitHub. Updated formatting
	Version 1.0 - Initial script

.EXAMPLE


#>
#-------------------------------------------------------[Initialisations]----------------------------------------------------------


	$Server = "servername.domain"
	$username = "domain\username"
	

#---------------------------------------#
#	Create Encrypted Credential File	#
#	 **Only needs to be run once**		#
#---------------------------------------#

	$secureString = Read-Host "Password for $username" -AsSecureString
	ConvertFrom-SecureString $secureString | out-file C:\temp\encrypted_credentials.txt


#-----------------------------------#
#	Read Encrypted Credential File	#
#-----------------------------------#

	$encrypted = Get-Content C:\temp\encrypted_credentials.txt | ConvertTo-SecureString
	$creds = New-Object System.Management.Automation.PSCredential($username, $encrypted);


#-----------------------------------#
# 	Create Mapped Drive to Server 	#
#-----------------------------------#

	net use \\$Server $creds.GetNetworkCredential().Password /USER:$username