$date = Get-Date -Format "MM-dd-yyyy"
$rand = Get-Random -Maximum 1000
$deploymentName = "AzInsiderDeployment-"+"$date"+"-"+"$rand"
$resourceGroup = "PSP_SNOWFLAKE_RG"


az deployment group create `
    --name $deploymentName `
    --template-file ".\templates\online_tuto.bicep" `
    --resource-group $resourceGroup `
    --parameters ".\templates\online_tuto_parameters.json" 

$functionId = az deployment group show -g $resourceGroup -n $deploymentName --query properties.outputs.functionId.value

Write-Host ""
Write-Host "##########################################################################################################"
Write-Host "$functionId"
Write-Host "###########################################################################################################"