$ErrorActionPreference = 'Stop'
$Error.Clear()

$resourceGroup = "PSP_SNOWFLAKE_RG"

$ScriptRootPath = "$PSScriptRoot\templates"

Write-Host ""
Write-Host "##########################################################"
Write-Host "Deploiement du Storage Account"
Write-Host "##########################################################"
$bicepFilePath = "$ScriptRootPath\azstorageaccount\storageaccount.bicep"

az deployment group create `
    --name "storageAccountDeployment" `
    --template-file "$bicepFilePath" `
    --resource-group $resourceGroup

$storageAccountName = az deployment group show -g $resourceGroup -n "storageAccountDeployment" --query properties.outputs.storageAccountName.value


Write-Host ""
Write-Host "##########################################################"
Write-Host "Deploiement de Application Insight"
Write-Host "##########################################################"
$bicepFilePath = "$ScriptRootPath\azApplicationInsight\applicationInsight.bicep"

az deployment group create `
    --name "AppInsightDeployment" `
    --template-file "$bicepFilePath" `
    --resource-group $resourceGroup

$appInsightConnectionString = az deployment group show -g $resourceGroup -n "AppInsightDeployment" --query properties.outputs.appInsightConnectionString.value
$appInsightId = az deployment group show -g $resourceGroup -n "AppInsightDeployment" --query properties.outputs.appInsightId.value


Write-Host ""
Write-Host "##########################################################"
Write-Host "Deploiement d'une Function Application"
Write-Host "##########################################################"
$bicepFilePath = "$ScriptRootPath\azFunctionApp\functionApplication.bicep"
$path = (Get-item $PSScriptRoot).Parent.FullName
#$packageUri = "$path\apps\eventTriggereventTrigger.zip"
$packageUri = "$path/apps/eventTrigger"
#$packageUri = "https://github.com/kaljob/bicepdeployment/blob/main/eventTrigger.zip"
Write-Host "Packge URI $packageUri"
az deployment group create `
    --name "FunctionAppDeployment" `
    --template-file "$bicepFilePath" `
    --resource-group $resourceGroup `
    --parameters appInsightId=$appInsightId `
    --parameters appInsightConnectionString=$appInsightConnectionString `
    --parameters storageAccountName=$storageAccountName `
    --parameters packageUri=$packageUri