clear-host
WRITE-HOST 'Password change script that connects to all domains.' -foregroundcolor yellow
WRITE-HOST 'When prompted use an administrator account/password that is consistent across all domains.' -foregroundcolor yellow
WRITE-HOST

$username=READ-HOST 'Which Username to change?'
$newpassword = READ-HOST -assecurestring 'New Password'
WRITE-HOST
WRITE-HOST 'Enter an administrator account. Leave off the domain name e.g. DOMAIN\.' -foregroundcolor yellow
$preuser = READ-HOST 'Admin Username'
$prepass = READ-HOST -assecurestring 'Password'
$secpassword = $prepass
$mycreds = New-Object System.Management.Automation.PSCredential ($preuser,$secpassword)


$data = Get-Content C:\Scripts

foreach ($line in $data)
    {
    Set-ADAccountPassword $username -NewPassword $newpassword -Credential $mycreds -Server $line -Reset
    WRITE-HOST $line -foregroundcolor green
    }

WRITE-HOST
WRITE-HOST 'Password change complete.' -foregroundcolor yellow
WRITE-HOST