$body = “
<lang=EN-US>
<div class=WordSection1>
<p class=MsoNormal>

<span lang=EN-IE style=font-family:Verdana,sans-serif;mso-fareast-language:EN-IE>
</span>
</p>
<p class=MsoNormal>
<span lang=EN-IE style=font-family:tahoma,sans-serif;mso-fareast-language:EN-IE>
</span>
</p>
<p>
&emsp;<span style=font-size:20.0pt;font-family:veranda,sans-serif;color:black><b>$domain</span>
<p>
&emsp;<span style=font-size:10.0pt;font-family:tahoma,sans-serif;color:#595959> $date </span>
<p>
&emsp;<b><span style=font-size:10.0pt;font-family:tahoma,sans-serif;color:black>Forest Replication Status: </span><span style=font-size:10.0pt;font-family:tahoma,sans-serif;color:green> $results </span></b>
</p>
"

$messageParameters = @{                        
	Subject = "Replication report for $env:USERDNSDOMAIN - $((Get-Date).ToShortDateString())"                        
    Body = $body
		Sort-Object
		ConvertTo-Html |
		Out-String     
	From = "$env:ComputerName.$env:USERDNSDOMAIN <noreply@domain.com>"                        
    To = "user@domain.com"                        
    SmtpServer = "smtp.domain.com"                        
}
Send-MailMessage @messageParameters -BodyAsHtml