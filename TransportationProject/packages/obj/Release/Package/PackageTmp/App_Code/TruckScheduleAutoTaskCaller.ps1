function runAutomaticTruckScheduleAppMethods{

#Sample call

#Set -Verbose if you would like to view output message

param (
	[Parameter(Mandatory=$True)] [string]$URL
)


try{

    $returnData = Invoke-WebRequest $URL
    Write-Verbose("Successfully Navigated");
}
catch{
    Write-Verbose ("Could not access the URL given. Please make sure the URL is correct.");
    throw
}


}