param location string = 'westeurope'
param namepre string = 'tryoutwebappdeploy3'
param wanames array = [
  'wa1'
  'wa2'
]

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

resource webapps 'Microsoft.Web/sites@2021-01-01' = [for waname in wanames: {
  name: '${namepre}${waname}'
  location: location
  kind: 'app'
  dependsOn: [
    appsvc
    vnet
  ]
  properties: {
    serverFarmId: appsvc.id
    virtualNetworkSubnetId: vnet.properties.subnets[0].id
    httpsOnly: true
    siteConfig:{
      vnetRouteAllEnabled: true
      http20Enabled: true
    }
  }
}]
