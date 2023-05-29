
param appInsightConnectionString string
param appInsightId string
param storageAccountName string
param packageUri string
param location string = resourceGroup().location
var azFunctionAppName = 'eastus2mkfunctionapppsp'
var serverFarmId = resourceId(subscription().subscriptionId, 'psplabtestfunctionapp', 'Microsoft.Web/serverfarms', 'ASP-psplabtestfunctionapp-0bf8')

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: azFunctionAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: serverFarmId
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(appInsightId, '2015-05-01').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightConnectionString
        }
        {
          name: 'ENABLE_ORYX_BUILD'
          value: 'true'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'PYTHON_ENABLE_DEBUG_LOGGING'
          value: '1'
        }
        {
          name: 'PYTHON_ENABLE_WORKER_EXTENSIONS'
          value: '1'
        }
        {
          name: 'PYTHON_ISOLATE_WORKER_DEPENDENCIES'
          value: '1'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '0'
        }
        {
          name: 'WEBSITE_TIME_ZONE'
          value: 'Eastern Standard Time'
        }
        {
          name: 'AzureWebJobsStorage'
          // 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, '2019-06-01').keys[0].value}' 
          value: storageAccountName
        }
        {
          name: 'AzureWebJobsDisableHomePage'
          value: 'true'
        }
      ]
      alwaysOn: false
      autoHealEnabled: true
      ftpsState: 'AllAllowed'
      linuxFxVersion: 'PYTHON|3.8'
      pythonVersion: '3.8'
      use32BitWorkerProcess: false
    }
    clientAffinityEnabled: false
    clientCertEnabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    hostNamesDisabled: false
    hyperV: false
    isXenon: false
    httpsOnly: true
    redundancyMode: 'None'
    scmSiteAlsoStopped: false

  }
}

resource function 'Microsoft.Web/sites/functions@2022-09-01' = {
  name: 'EventGridTrigger'
  parent: functionApp
  properties: {
    // test_data: 'sample.dat'
    files: {
      '__init__.py': loadTextContent('../../../apps/eventTrigger/__init__.py')
      // 'function.json': '${packageUri}/function.json'
      // 'host.json': '${packageUri}/host.json'
      // 'local.settings.json': '${packageUri}/local.settings.json'
      // 'requirements.txt': '${packageUri}/requirements.txt'
      // 'sample.dat': '${packageUri}/sample.dat'
    }
    isDisabled: false
    language: 'python'
  }
}

// resource function 'Microsoft.Web/sites/extensions@2022-09-01' = {
//   name: 'MSDeploy'
//   parent: functionApp
//   properties: {
//     packageUri: packageUri
//   }
// }


output functionId string = function.id
