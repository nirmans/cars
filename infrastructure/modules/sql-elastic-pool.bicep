param location string
param sqlServerName string
param sqlElasticPoolName string
param sqladminusername string
@secure()
param sqladminpassword string

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqladminusername
    administratorLoginPassword: sqladminpassword
  }
}

resource sqlElasticPool 'Microsoft.Sql/servers/elasticPools@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlElasticPoolName
  location: location
  sku: {
    name: 'StandardPool'
    tier: 'Standard'
    capacity: 50
  }
  properties: {
    perDatabaseSettings: {
      minCapacity: 0
      maxCapacity: 20
    } 
  }
}

