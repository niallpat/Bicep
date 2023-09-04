/*
 * DISCLAIMER
 *
 * This code is provided "AS IS" without warranty of any kind, either express or implied, 
   including but not limited to the warranties of merchantability, fitness for a particular purpose and non-infringement. 
   In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an 
   action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other 
   dealings in the software. Please test all code before use.
 */

param logicAppName string = 'MyLogicApp'
param location string = 'West Europe' // Change to your desired region

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      actions: {
        // Define your Logic App workflow actions here
        Initialize_variable: {
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'variableName'
                type: 'string'
                value: 'Hello, Logic App!'
              }
            ]
          }
        }
        // Add more actions as needed
      }
      triggers: {
        // Define your Logic App triggers here
        manualTrigger: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {}
          }
        }
        // Add more triggers as needed
      }
    }
    state: 'Enabled'
  }
}

output logicAppResourceId string = logicApp.id
