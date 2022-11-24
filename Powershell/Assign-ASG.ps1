Write-Verbose "Conencting to Azure..."
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# You can add more ASGs or remove ASG just remember add/remove asg under $asgName
$asg1 = "asg1"  
$asg2 = "asg2"
$asg3 = "asg3"

$asgName = @($asg1,$asg2,$asg3)

$Vm = Get-AzVM | where Name -Like "nameofvm*" # Name of VM or VMs

$Asg=@()
  
foreach ($AsgAdd in $AsgName) {
    $nic = Get-AzNetworkInterface -ResourceId $Vm.NetworkProfile.NetworkInterfaces.id
    $Asg += Get-AzApplicationSecurityGroup -Name $AsgAdd
}

$nic.IpConfigurations[0].ApplicationSecurityGroups = $Asg
$nic | Set-AzNetworkInterface
 