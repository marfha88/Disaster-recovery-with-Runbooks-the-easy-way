param automationAccount_name string = ''
param location string = ''
param sub string = ''

@description('Adds the time as a tag')
param utctime string = utcNow('yyyyMMddTHHmm')

@description('List of tags passed from input')
param tags object = {
  environment: 'prod'
  deploymenttool:  'bicep'
  lastreview:  utctime
}

resource automationAccount_resource 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: automationAccount_name
  tags: tags
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: true
    disableLocalAuth: false
          RuntimeConfiguration: { 
      powershell: {
        builtinModules: {
          Az: '8.0.0'
        }
      }
      powershell7: {
        builtinModules: {
          Az: '7.3.2'
        }
      }
    }
    
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {
      }
    }
  }
}

resource automationAccount_connections 'Microsoft.Automation/automationAccounts/connections@2020-01-13-preview' = {
  parent: automationAccount_resource
  name: '${automationAccount_name}-VMs' // you could give it a better name here but for simplicity i just reused the same name :)
  properties: {
    fieldDefinitionValues: {
      AutomationCertificateName: '${automationAccount_name}-VMs'
      SubscriptionID: sub
    }
    connectionType: {
      name: 'Azure'
    }
  }
}

resource automationAccount_runbook 'Microsoft.Automation/automationAccounts/runbooks@2019-06-01' = {
  parent: automationAccount_resource
  name: automationAccount_name // you could give it a better name here but for simplicity i just reused the same name :)
  location: location
  properties: {
    runbookType: 'PowerShell7'
    logVerbose: true
    logProgress: true
    description: 'This Runbook assign ASG after a failover from region West Europe to North Europe'
    draft: {
      inEdit: false
    }
  }
}


