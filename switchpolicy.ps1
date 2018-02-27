# Parameters // Change according to your settings
$ResourceGroupName = 'acf-api-mgmt' # Name of the RG which contains the APIM service
$APIName = 'northeu.azurewebsites.net' # Name of your API
$PolicyFileNameFirst = 'policyfile_west.txt' # Policyfile to switch to or from
$PolicyFileNameSecond = 'policyfile_north.txt' # Policyfile to switch to or from
$PSScriptRoot = "C:\Users\smanalo\Source\Repos\PingAPIMgmt\" # Working directory, make sure your files are in this one


#Prompt for switch 
$whereto = ''
$whereto = Read-Host -Prompt 'Switch to this API (first,second)'
Write-Host "You chose" $whereto
 

# Get context and set URL
$ApiMgmtObj = Get-AzureRmApiManagement -ResourceGroupName $ResourceGroupName
$ApimUrl = $ApiMgmtObj.RuntimeUrl
$ApimService = $ApiMgmtObj.Name

$ApiMgmtContext = New-AzureRmApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $ApimService
$switchapi = Get-AzureRmApiManagementApi -Context $ApiMgmtContext -Name $APIName

# Read Policy File
if ($whereto -eq 'first') {$PolicyFileName = $PolicyFileNameFirst; 
        Write-Host "Please wait, switching to First API"; }
    elseif ($whereto -eq 'second') {$PolicyFileName = $PolicyFileNameSecond; 
        Write-Host "Please wait, switching to Second API"; }
    else { Write-Host "You did not enter a valid option"; 
       exit; }


$PolicyFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $PolicyFileName))


Set-AzureRmApiManagementPolicy -Context $ApiMgmtContext -ApiId $switchapi.ApiId -PolicyFile $PolicyFile

$Policy = Get-AzureRmApiManagementPolicy -Context $ApiMgmtContext -ApiId $switchapi.ApiId

Write-Host "Current policy is: " $Policy