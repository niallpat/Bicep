param serviceBusNamespaceName string
param vnetName string
param subnetName string
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {}
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-02-01' = {
  name: '${serviceBusNamespace.name}-PrivateEndpoint'
  location: location
  properties: {
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
    }
    privateLinkServiceConnections: [
      {
        name: '${serviceBusNamespace.name}-PrivateLinkServiceConnection'
        properties: {
          privateLinkServiceId: serviceBusNamespace.id
          groupIds: [
            'namespace'
          ]
        }
      }
    ]
  }
}
