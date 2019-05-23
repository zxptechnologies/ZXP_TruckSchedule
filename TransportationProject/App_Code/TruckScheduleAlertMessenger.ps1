function SendAlertMessage{

#Sample call
#SendAlertMessage -From "someuser@mail.com" -To "anotheruser@mail.com" -Subject "TESTING" -Body "TEST" -SMTPServer "smtp.gmail.com" -SMTPPort "587"
#             -EmailCredentialsUser "validEmailAccountOnSMTPServerR@gmail.com" -EmailCredentialsPassword "password"  -Verbose

#Set -Verbose if you would like to view output message

param (
	[Parameter(Mandatory=$True)] [string]$From,
	[Parameter(Mandatory=$True)] [string[]]$To,
	[string[]]$CC,
	[string[]]$BCC,
	[Parameter(Mandatory=$True)] [string]$Subject,
	[Parameter(Mandatory=$True)] [string]$Body,
	[Parameter(Mandatory=$True)] [string]$SMTPServer,
	[Parameter(Mandatory=$True)] [string]$SMTPPort,
	[Parameter(Mandatory=$True)] [string]$EmailCredentialsUser,
	[Parameter(Mandatory=$True)] [string]$EmailCredentialsPassword
)

    
	$retries = 3  #Max Count of retries to send email
	$secondsDelay = 2 #Delay in seconds before retrying
    
    $retrycount = 0 #counter of actual retries
    $completed = $false

   try{
        $secPass = ConvertTo-SecureString $EmailCredentialsPassword -AsPlainText -Force
	    $cred = new-object System.Management.Automation.PSCredential($EmailCredentialsUser, $secPass);
   }
   catch{
        Write-Verbose ("Cannot set email credentials with the information provided. Please check if the username and password is correct.");
        throw
   }
    while (-not $completed -or  $retrycount -ge $retries) {
        Write-Verbose ("Count {0}" -f $retrycount)
        try {

            if($CC -and $BCC){
                Send-MailMessage -From $From -To $To -Cc $CC -Bcc $BCC -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $cred -ErrorAction Stop
            }
            elseif($CC){
                Send-MailMessage -From $From -To $To -Cc $CC -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $cred -ErrorAction Stop
            }
            elseif($BCC){
                Send-MailMessage -From $From -To $To -Bcc $BCC -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $cred -ErrorAction Stop
            }
            else{
                Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $cred -ErrorAction Stop
            }
			
           
				Write-Verbose ("Email sent successfully.")
				$completed = $true
        } 
		catch {
            if ($retrycount -ge $retries) {
                Write-Verbose ("Send Alert Message failed the maximum number of {0} retry times." -f  $retrycount)
                throw
            } else {
                Write-Verbose ("Send Alert Message failed. Retrying in {0} seconds." -f $secondsDelay)
                Start-Sleep $secondsDelay
                $retrycount++
            }
        }
    }
}
