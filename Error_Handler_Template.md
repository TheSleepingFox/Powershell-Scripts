# Error Handler Template

```powershell
# Error Handling Module for Powershell Scripts
#
# Written by Jacob Dyson - 2020-01-17

# Define Functions
function ErrorHandler($errorhandled) 
{
$errorhandled |Add-Content $ErrorLog
$errorhandled.InvocationInfo|out-string|Add-Content $ErrorLog

}

function SendEmail() 
{
#Powershell Version
#Variables
$relayserver="eRelay.raa.com.au"
$emailrecipient="InfrastructureServices@raa.com.au"
$emailsend=$env:Computername +"@raa.com.au"
$subject="$env:computername $PSCommandPath"
Send-MailMessage -From $emailSend -To $emailrecipient -Subject $subject -Body $(get-content $errorlog) -Priority High -SmtpServer $relayserver

# Blat Email Sending Variables
#$blat='.\blat.exe'
#$relayserver="eRelay.raa.com.au"
#$emailrecipient="InfrastructureServices@raa.com.au"
#$emailsend=$env:Computername +"@raa.com.au"
#$subject="$env:computername $PSCommandPath"
#& $blat $errorLog -to $emailrecipient -s $subject -f $emailSend -Server $relayserver 
}

# Enable error trapping for the main script
trap { ErrorHandler $_; continue}

# Define error log location and clean up from last run
$ErrorLog = 'C:\Scripts\WSUSGroupSync\error.log'
If (Test-Path $ErrorLog) {remove-item $ErrorLog}

### SCRIPT CONTENT START
###NOTE: IF YOU HAVE ANY FOREACH-OBJECT STATEMENTS OR SIMILAR YOU WILL NEED TO ADD A TRAP STATEMENT TO IT
###      trap { ErrorHandler $_; continue}

### SCRIPT CONTENT END

#Email the results of any errors if they exist
If (Test-Path $ErrorLog) {SendEmail}
```