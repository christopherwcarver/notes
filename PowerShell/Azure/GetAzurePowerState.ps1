<#
auth: Carver, Christopher
desc: This script retrieves the state of the Azure server
note: To be used by Orchestrator.
#>

<# SUBSCRIBE TO PUBLISHED DATA HERE
   Dev Note: Replace INSERT VARIABLE and INSERT PUBLISHED DATA in the lines
   below from Orchestrator.
-----------------------------------------------------------------------------#>
$azureSubscriptionName = "FILL ME IN"
$azureCloudService = "FILL ME IN"
$azureVM = "FILL ME IN"
$azurePublishSettingsPath = "FILL ME IN"

<# DEFINE PUBLISH DATA HERE
   Dev Note: This is where we define what is being published. Though
   Orchestrator can extract all globally scoped variables, this helps with
   informing what is being published back to Orchestrator.
-----------------------------------------------------------------------------#>
$azureVMPowerState = "Unknown"

# set return code, information, and trace to defaults
# valid return codes:
#  0 -- Success
#  1 -- Success with info
#  2 -- Error
#  3 -- Fatal Error
# valid return states:
#  SUCCESS -- The execution and operation was successful
#  FAILURE -- The execution or operation failed
$retCode = 0
$retState = "SUCCESS"
$retInfo = ""
$retTrace= ""

<# MAIN
-----------------------------------------------------------------------------#>

$retTrace += "`r`n$(Get-Date -format 'u')`t Entering Get Azure VM Power State."
$retTrace += "`r`n$(Get-Date -format 'u')`t   Parameters:"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Subscription Name: $azureSubscriptionName"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Azure Cloud Service: $azureCloudService"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Azure VM: $azureVM"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Azure Publish Settings Path: $azurePublishSettingsPath" 

try 
{
  $ErrorActionPreference = "Stop"

  $retTrace += "`r`n$(Get-Date -format 'u')`t Importing Azure modules."
  Import-Module Azure 

  $retTrace += "`r`n$(Get-Date -format 'u')`t Importing Azure settings."
  Import-AzurePublishSettingsFile –PublishSettingsFile $azurePublishSettingsPath 

  $retTrace += "`r`n$(Get-Date -format 'u')`t Setting Azure subscription."
  Select-AzureSubscription -SubscriptionName $azureSubscriptionName

  $retTrace += "`r`n$(Get-Date -format 'u')`t Retrieving Azure server power state."
  $azureVMPowerState = (Get-AzureVM -ServiceName $azureCloudService -Name $azureVM).PowerState

  $retTrace += "`r`n$(Get-Date -format 'u')`t Azure server power state: $azureVMPowerState"  
  $retInfo += "`r`n$(Get-Date -format 'u')`t Azure server power state: $azureVMPowerState"
}
catch {
  # preserve the error
  $retCode = 2
  $retState = "FAILURE"
  $retInfo = "Failure occurred while retrieving Azure power state." 
  $retTrace += "`r`n$(Get-Date -format 'u')`t Exception: " + $_.Exception
}
finally
{
  #Reset the error action pref to default
  $ErrorActionPreference = "Continue"
}

$retTrace += "`r`n$(Get-Date -format 'u')`t Exiting Get Azure VM Power State."