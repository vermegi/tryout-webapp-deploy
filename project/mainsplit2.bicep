param location string = 'westeurope'
param namepre string = 'tryoutwebappdeploy'

resource appsvc 'Microsoft.Web/serverfarms@2020-06-01' existing = {
  name: '${namepre}asp'
}

resource webapp2 'Microsoft.Web/sites@2020-06-01' = {
  name: '${namepre}wa2'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appsvc.id
  }
}

resource webapp2vnet 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  name: '${webapp2.name}/virtualNetwork'
  properties: {
    subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', '${namepre}vnet', '${namepre}sn')
  }
}
