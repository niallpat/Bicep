/*
 * DISCLAIMER
 *
 * This code is provided "AS IS" without warranty of any kind, either express or implied, 
   including but not limited to the warranties of merchantability, fitness for a particular purpose and non-infringement. 
   In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an 
   action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other 
   dealings in the software. Please test all code before use.
 */



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
