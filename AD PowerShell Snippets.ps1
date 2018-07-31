break

#---------------------------------------------------------- 
# LOAD ASSEMBLIES AND MODULES 
#---------------------------------------------------------- 
Try 
{ 
  Import-Module ActiveDirectory -ErrorAction Stop 
} 
Catch 
{ 
  Write-Host "[ERROR]`t ActiveDirectory Module couldn't be loaded. Script will stop!" 
  Exit 1 
} 


# List Stale Groups

Get-ADGroup -Filter * -Properties Name, DistinguishedName, GroupCategory, GroupScope, whenCreated, whenChanged, member, memberof, sIDHistory, SamAccountName, Description |
    Select-Object Name, DistinguishedName, GroupCategory, GroupScope, whenCreated, whenChanged, member, memberof, SID, SamAccountName, Description, `
        @{name='MemberCount';expression={$_.member.count}}, `
        @{name='MemberOfCount';expression={$_.memberOf.count}}, `
        @{name='SIDHistory';expression={$_.sIDHistory -join ','}}, `
        @{name='DaysSinceChange';expression=`
            {[math]::Round((New-TimeSpan $_.whenChanged).TotalDays,0)}} |
    Sort-Object Name | ogv


# Trusts

    Get-ADTrust -Filter * | ogv


# Find FSMO's

    Get-ADDomain | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

    Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster

    Get-ADDomainController -Service PrimaryDC -Discover


# Add new sites & subnets

    Import-Csv .\ADSites.csv | New-ADReplicationSite

    Import-Csv .\ADSites.csv | New-ADReplicationSubnet


# Turn on change notification

    Get-ADReplicationSiteLink -filter * -Properties Options |
        Where-Object { $_.Options -eq $null } |
        Set-ADReplicationSiteLink -Replace @{'options'=5}


# Find manual Connection Objects

    Get-ADReplicationConnection -Filter {Autogeneratesd -eq $false}


# Get Replicaiton Failures

    Get-ADReplicationFailure -Scope Forest | ogv

    Get-ADReplicationFailure -Scope Domain | ogv


# Replication health overview

    Get-ADReplicationPartnerMetadata -PartnerType Both -Scope Domain


# Site Link Info

    Get-ADObject -Filter 'objectClass -eq "siteLink"' -Searchbase (Get-ADRootDSE).ConfigurationNamingContext -Property Options, Cost, ReplInterval, SiteList, Schedule | 
        Select-Object Name, `
            @{Name="SiteCount";Expression={$_.SiteList.Count}}, `
            Cost, `
            ReplInterval, `
            @{Name="Schedule";Expression={If($_.Schedule){If(($_.Schedule -Join " ").Contains("240")){"NonDefault"}Else{"24×7"}}Else{"24×7"}}}, `
            Options | 
        Sort Name |
        Format-Table * -AutoSize