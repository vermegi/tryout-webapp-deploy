param location string = 'westeurope'
param namepre string = 'tryoutwebappdeploy'

resource appsvc 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${namepre}asp'
  location: location
  sku: {
    name: 'S1'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: '${namepre}vnet'
  location: location
  properties:{
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${namepre}sn'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

resource webapp1 'Microsoft.Web/sites@2020-06-01' = {
  name: '${namepre}wa1'
  location: location
  kind: 'app'
  dependsOn: [
    appsvc
    vnet
  ]
  properties: {
    serverFarmId: appsvc.id
  }
}

resource webapp1vnet 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  name: '${webapp1.name}/virtualNetwork'
  properties: {
    subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, '${namepre}sn')
  }
}
