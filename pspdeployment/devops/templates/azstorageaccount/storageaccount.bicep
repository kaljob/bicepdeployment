param location string = resourceGroup().location

var accountName = 'eastus2mksnowflakesa'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: accountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: true
    allowBlobPublicAccess: true
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
    sasPolicy: {
      expirationAction: 'Log'
      sasExpirationPeriod: '14.00:00:00'
    }
    encryption: {
      services: {
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource webjobs_default 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    deleteRetentionPolicy: {
      enabled: true
      days: 14
    }
  }
}

resource webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'azure-webjobs-hosts'
  parent:webjobs_default
  properties: {
    publicAccess: 'None'
  }
}

resource webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'azure-webjobs-secrets'
  parent:webjobs_default
  properties: {
    publicAccess: 'None'
  }
}


output storageAccountName string = accountName
