#Prompt for switch 
$whereto = ""
$whereto = Read-Host -Prompt 'Switch to this API (westeu,northeu)'
Write-Host "You chose" $whereto
 

# Get context and set URL
$ApiMgmtObj = Get-AzureRmApiManagement -ResourceGroupName acf-api-mgmt
$ApimUrl = $ApiMgmtObj.RuntimeUrl
$ApimService = $ApiMgmtObj.Name

$ApiMgmtContext = New-AzureRmApiManagementContext -ResourceGroupName acf-api-mgmt -ServiceName $ApimService
$switchapi = Get-AzureRmApiManagementApi -Context $ApiMgmtContext -Name "northeu.azurewebsites.net"

# Read Policy File
$PolicyFileNameWest = 'policyfile_west.txt'
$PolicyFileNameNorth = 'policyfile_north.txt'
if ($whereto -eq 'westeu') {$PolicyFileName = $PolicyFileNameWest; 
        Write-Host "Please wait, switching to Western Europe"; }
    elseif ($whereto -eq 'northeu') {$PolicyFileName = $PolicyFileNameNorth; 
        Write-Host "Please wait, switching to North Europe"; }
    else { Write-Host "You did not enter a valid region"; 
       exit; }

$PSScriptRoot = "C:\Users\smanalo\Source\Repos\PingAPIMgmt\"

$PolicyFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $PolicyFileName))


Set-AzureRmApiManagementPolicy -Context $ApiMgmtContext -ApiId $switchapi.ApiId -PolicyFile $PolicyFile

$Policy = Get-AzureRmApiManagementPolicy -Context $ApiMgmtContext -ApiId $switchapi.ApiId

Write-Host "Current policy is: " $Policy