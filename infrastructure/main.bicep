targetScope = 'resourceGroup'

//Parameters
param location string
param appServicePlanName string
param appServiceName string
param sqlServerName string
param sqlElasticPoolName string
param vnetName string
param appInsightsName string
param sqladminusername string
@secure()
param sqladminpassword string

//Modules
module appService './modules/app-service.bicep' = {
  name: 'appServiceDeployment'
  params:{
    location: location
    appServicePlanName: appServicePlanName
    appServiceName: appServiceName
  }
}

module sqlElasticPool './modules/sql-elastic-pool.bicep' = {
  name: 'sqlElasticPoolDeployment'
  params: {
    location: location
    sqlElasticPoolName: sqlElasticPoolName
    sqlServerName: sqlServerName
    sqladminusername: sqladminusername
    sqladminpassword: sqladminpassword
  }
}

module vnet './modules/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    location: location
    vnetName: vnetName
  }
}

module monitoring './modules/monitoring.bicep' = {
  name: 'monitoringDeployment'
  params: {
    location: location
    appInsightsName: appInsightsName
  }
}
