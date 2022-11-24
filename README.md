# Disaster-recovery-with-Runbooks-the-easy-way

The powershell script needs to be added to the runbook and be published.
You can of coruse create more complex script but the script in the Powershell folder can help you understand how to use it with Recovery Services vault > Recovery Plans (Site Recovery)


You can use the below command to deploy locally.
This deployment is targeting resource group

```
az login
az account set -s "subscriptionid"
az deployment group what-if -g rgname --name rollname1 -f .\AutomationAccount.bicep
az deployment group create -g rgname --name rollname1 -f .\AutomationAccount.bicep
```