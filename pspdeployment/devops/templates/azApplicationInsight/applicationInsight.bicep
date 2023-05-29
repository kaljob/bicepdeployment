param location string = resourceGroup().location
var appInsightName = 'eastus2mkpspallicationinsight'

resource appInsight 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    IngestionMode: 'ApplicationInsights'
    Request_Source: 'rest'
    RetentionInDays: 90
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output appInsightConnectionString string = appInsight.properties.ConnectionString
output appInsightId string = appInsight.id
