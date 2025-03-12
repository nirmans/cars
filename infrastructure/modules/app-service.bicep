param location string
param appServicePlanName string
param appServiceName string

// Define variables for hardcoded values
var alwaysOn = false
var ftpsState = 'FtpsOnly'
var sku = 'Basic'
var skuCode = 'B1'
var linuxFxVersion = 'NODE|22-lts'

// App Service Plan (Hosting Plan)
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
    zoneRedundant: false
  }
  sku: {
    tier: sku
    name: skuCode
  }
}

// Web App (App Service)
resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  properties: {
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: alwaysOn
      ftpsState: ftpsState
    }
    serverFarmId: appServicePlan.id
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
  }
  dependsOn: [
    appServicePlan
  ]
}

resource scmPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: appService
  name: 'scm'
  properties: {
    allow: false
  }
}

resource ftpPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: appService
  name: 'ftp'
  properties: {
    allow: false
  }
}
