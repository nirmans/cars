param location string
param vnetName string

var subnets = [
  {
    name: 'Subnet-1'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'Subnet-2'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'Subnet-3'
    addressPrefix: '10.0.2.0/24'
  }
  {
    name: 'Subnet-4'
    addressPrefix: '10.0.3.0/24'
  }
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
      }
    }]
  }
}
